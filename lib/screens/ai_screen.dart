import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<({String text, bool isUser})> _messages = [];
  bool _thinking = false;

  static const _quickActions = [
    'Create a savings plan',
    'Track my expenses',
    'Reduce my spending',
    'Review my budget',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send(String prompt) async {
    final text = prompt.trim();
    if (text.isEmpty || _thinking) return;
    setState(() {
      _messages.add((text: text, isUser: true));
      _thinking = true;
    });
    _controller.clear();
    _scrollToEnd();

    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _messages.add((text: _replyFor(text), isUser: false));
      _thinking = false;
    });
    _scrollToEnd();
  }

  String _replyFor(String prompt) {
    final lower = prompt.toLowerCase();
    if (lower.contains('save') || lower.contains('saving')) {
      return 'Based on your income of Rp 8.500.000 and spending of '
          'Rp 4.300.000, I recommend allocating Rp 3.000.000 per month '
          'to savings. That reaches your Trip to Bali goal about '
          '2 months earlier.';
    }
    if (lower.contains('expense') || lower.contains('spend')) {
      return 'Your biggest category this month is Shopping at Rp 1.645.000 '
          '(38,3% of spending). Cutting it by 15% would free up '
          'Rp 246.750 — enough to close the Transport overspend.';
    }
    return 'Here is what I see: your total balance is Rp 24.350.000 across '
        '4 wallets, and 71,7% of this month\'s budget is already used. '
        'Want me to suggest a plan for the remaining days?';
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => state.selectTab(0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.ink,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const Expanded(
                child: Column(
                  children: [
                    Text(
                      'New Chat',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.ink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.graphic_eq_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _messages.isEmpty ? _emptyState() : _conversation(),
        ),
        _composer(),
        const SizedBox(height: 96),
      ],
    );
  }

  Widget _emptyState() {
    final suggestions = AppState.instance.aiSuggestions;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      children: [
        const SizedBox(height: 8),
        const Text(
          'Hi, Amanda',
          style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
        ),
        const Text(
          'Where do we start?',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(child: _SuggestionCard(suggestion: suggestions[0], onTap: _send)),
            const SizedBox(width: 12),
            Expanded(child: _SuggestionCard(suggestion: suggestions[1], onTap: _send)),
          ],
        ),
        const SizedBox(height: 26),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'AI can make mistakes. Double-check important amounts.',
              style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted),
            ),
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Trending Quick Action',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickActions
              .map(
                (action) => PillChip(
                  label: action,
                  dense: true,
                  leading: Icons.auto_awesome,
                  onTap: () => _send(action),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _conversation() {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        for (final message in _messages)
          Align(
            alignment:
                message.isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              constraints: const BoxConstraints(maxWidth: 300),
              decoration: BoxDecoration(
                gradient: message.isUser ? AppColors.brandGradient : null,
                color: message.isUser ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(message.isUser ? 18 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 18),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: message.isUser ? Colors.white : AppColors.ink,
                ),
              ),
            ),
          ),
        if (_thinking)
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.inkMuted.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
          ),
      ],
    );
  }

  Widget _composer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 4, 6, 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color(0x140E2A21),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.add_rounded, size: 20, color: AppColors.inkMuted),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: _send,
                decoration: const InputDecoration(
                  hintText: 'Ask me anything...',
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _send(_controller.text),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.suggestion, required this.onTap});

  final AiSuggestion suggestion;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(suggestion.body),
      child: Container(
        height: 148,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: suggestion.gradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    suggestion.icon,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.north_east_rounded,
                  size: 14,
                  color: Colors.white70,
                ),
              ],
            ),
            const Spacer(),
            Text(
              suggestion.title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              suggestion.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                height: 1.35,
                color: Colors.white.withOpacity(0.88),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
