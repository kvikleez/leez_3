import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Message {
  final String title;
  final String description;
  final String date;
  final String category;
  final String status;
  final String icon;

  Message({
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.status,
    required this.icon,
  });
}

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Travelling', 'Support'];
  
  final List<Message> messages = [
    Message(
      title: 'leez Support',
      description: 'leez: This case is closed due to inac...',
      date: '21/2/25',
      category: 'Support',
      status: 'Closed',
      icon: 'assets/logo/quickleez_1.png', // Ensure this asset exists
    ),
    // Add more messages here as needed
  ];

  List<Message> get filteredMessages {
    if (selectedFilter == 'All') return messages;
    return messages.where((message) => message.category == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with search and menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // Implement search functionality
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz),
                        onPressed: () {
                          // Implement menu functionality
                        },
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Filter chips
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final isSelected = selectedFilter == filter;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        backgroundColor: isSelected ? Colors.black : Colors.grey[200],
                        label: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? const Color.fromARGB(255, 255, 255, 255) : Colors.black,
                          ),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Messages list
              Expanded(
                child: ListView.builder(
                  itemCount: filteredMessages.length,
                  itemBuilder: (context, index) {
                    final message = filteredMessages[index];
                    
                    return ListTile(
                      onTap: () {
                        // Navigate to ChatScreen on tap
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChatScreen()),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Image.asset(
                          message.icon,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: 24,
                        ),
                      ),
                      title: Text(message.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(message.description),
                          Text(
                            message.status,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        message.date,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool _isEmojiVisible = false;

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(ChatMessage(
          text: _controller.text,
          isSentByMe: true,
          timestamp: DateTime.now(),
        ));
        _controller.clear();
      });
      _scrollToBottom();
    }
  }

  void _sendImage(File image) {
    setState(() {
      messages.add(ChatMessage(
        image: image,
        isSentByMe: true,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _sendImage(File(pickedFile.path));
    }
  }

  void _toggleEmojiPicker() {
    setState(() {
      _isEmojiVisible = !_isEmojiVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Chat UI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_emotions),
            onPressed: _toggleEmojiPicker,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messages[index];
              },
            ),
          ),
          if (_isEmojiVisible)
            SizedBox(
              height: 200,
              child: const Placeholder(), // Replace with an emoji picker
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String? text;
  final File? image;
  final bool isSentByMe;
  final DateTime timestamp;

  const ChatMessage({
    super.key, 
    this.text,
    this.image,
    required this.isSentByMe,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                image!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          if (text != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: isSentByMe ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                text!,
                style: TextStyle(
                  color: isSentByMe ? const Color.fromARGB(255, 255, 255, 255) : Colors.black,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${timestamp.hour}:${timestamp.minute}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
