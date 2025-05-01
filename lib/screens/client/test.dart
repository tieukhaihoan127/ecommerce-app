import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  final bool isLoggedIn;

  const TestPage({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  State<TestPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<TestPage> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _ratingCommentController = TextEditingController();
  double _userRating = 0;
  final List<Map<String, dynamic>> _comments = [];
  final List<Map<String, dynamic>> _ratings = [];

  void _submitComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments.add({
          'text': _commentController.text,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _commentController.clear();
      });
    }
  }

  void _submitRating() {
    if (_userRating > 0) {
      setState(() {
        _ratings.add({
          'rating': _userRating,
          'comment': _ratingCommentController.text,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _userRating = 0;
        _ratingCommentController.clear();
      });
    }
  }

  double _averageRating() {
    if (_ratings.isEmpty) return 0;
    return _ratings.map((e) => e['rating'] as double).reduce((a, b) => a + b) / _ratings.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Detail")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Rating Section ---
            Text("⭐ Average Rating: ${_averageRating().toStringAsFixed(1)}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            if (widget.isLoggedIn) ...[
              Text("Rate this product:", style: TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: _userRating,
                onChanged: (val) {
                  setState(() {
                    _userRating = val;
                  });
                },
                min: 0,
                max: 5,
                divisions: 5,
                label: '$_userRating',
              ),
              TextField(
                controller: _ratingCommentController,
                decoration: const InputDecoration(
                  labelText: "Comment (optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _submitRating, child: const Text("Submit Rating")),
              const Divider(height: 32),
            ] else ...[
              Text("Đăng nhập để đánh giá sản phẩm.", style: TextStyle(color: Colors.grey)),
              const Divider(height: 32),
            ],

            // --- Comment Section ---
            Text("💬 Leave a comment (No login required):", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: "Write your comment here...",
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _submitComment, child: const Text("Submit Comment")),

            const SizedBox(height: 24),
            Text("📢 Comments:", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (var comment in _comments)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(comment['text']),
                  subtitle: Text("At ${comment['timestamp']}"),
                ),
              ),

            const SizedBox(height: 24),
            if (_ratings.isNotEmpty) ...[
              Text("📊 Ratings:", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              for (var rate in _ratings)
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text("⭐ ${rate['rating']}"),
                    subtitle: Text(rate['comment'].isNotEmpty
                        ? rate['comment']
                        : "No comment. At ${rate['timestamp']}"),
                  ),
                ),
            ]
          ],
        ),
      ),
    );
  }
}