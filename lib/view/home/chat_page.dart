import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:personifyu/common_widget/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.title});

  final String title;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('ws://10.0.2.2:8000/sendMessage'),
  );
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _channel.stream.listen(
      (message) {
        setState(() {
          _messages.add(ChatMessage(text: message, isUser: false));
          _scrollDown();
        });
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket closed');
      },
    );
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    if (_isSending || message.trim().isEmpty) return;

    setState(() {
      _isSending = true;
      _messages.add(ChatMessage(text: message, isUser: true));
    });

    try {
      _channel.sink.add(message);
    } catch (e) {
      print('Send error: $e');
      setState(() {
        _messages.add(ChatMessage(text: "Error Occurred", isUser: false));
      });
    } finally {
      setState(() {
        _isSending = false;
      });
      _textController.clear();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          if (_isSending)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (message) {
                      _sendChatMessage(message);
                    },
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Enter a Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.black), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFf25D366)), // Border color when focused
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _sendChatMessage(_textController.text),
                  icon: const Icon(
                    Icons.send,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(child: Text('A')),
            SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                message.text,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 10),
            CircleAvatar(child: Text('U')),
          ],
        ],
      ),
    );
  }
}
