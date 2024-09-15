import 'package:bai_system/component/app_bar_component.dart';
import 'package:bai_system/core/helper/asset_helper.dart';
import 'package:bai_system/representation/support.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  static const routeName = '/faq';

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<_FAQCategory> _filteredCategories = [];
  int? _expandedCategoryIndex;
  int? _expandedQuestionIndex;

  @override
  void initState() {
    super.initState();
    _filteredCategories = _faqCategories;
    _searchController.addListener(_filterFAQs);
  }

  void _filterFAQs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = _faqCategories;
      } else {
        _filteredCategories = _faqCategories
            .map((category) {
              final filteredQuestions = category.questions
                  .where((question) =>
                      question.question.toLowerCase().contains(query) ||
                      question.answerText.toLowerCase().contains(query))
                  .toList();
              return _FAQCategory(category.title, filteredQuestions);
            })
            .where((category) => category.questions.isNotEmpty)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCom(
        leading: true,
        appBarText: 'FAQs',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search FAQs',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline, width: 2),
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              itemCount: _filteredCategories.length,
              itemBuilder: (context, categoryIndex) {
                final category = _filteredCategories[categoryIndex];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Theme.of(context).colorScheme.surface,
                  surfaceTintColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      title: Text(
                        category.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      childrenPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      onExpansionChanged: (expanded) {
                        setState(() {
                          _expandedCategoryIndex =
                              expanded ? categoryIndex : null;
                          _expandedQuestionIndex = null;
                        });
                      },
                      trailing: Icon(
                        _expandedCategoryIndex == categoryIndex
                            ? Icons.expand_less_sharp
                            : Icons.expand_more_sharp,
                      ),
                      children: category.questions.asMap().entries.map((entry) {
                        final questionIndex = entry.key;
                        final question = entry.value;
                        return _CustomFAQ(
                          question: question.question,
                          answerText: question.answerText,
                          imagePaths: question.imagePaths,
                          isExpanded: questionIndex == _expandedQuestionIndex,
                          onExpansionChanged: (expanded) {
                            setState(() {
                              _expandedQuestionIndex =
                                  expanded ? questionIndex : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                child: GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(SupportScreen.routeName),
                  child: RichText(
                    text: TextSpan(
                      text: 'Can\'t find what you\'re looking for? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Contact Support',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _CustomFAQ extends StatelessWidget {
  final String question;
  final String answerText;
  final List<String> imagePaths;
  final bool isExpanded;
  final Function(bool) onExpansionChanged;

  const _CustomFAQ({
    required this.question,
    required this.answerText,
    this.imagePaths = const [],
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
              )),
      onExpansionChanged: onExpansionChanged,
      initiallyExpanded: isExpanded,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Text(
            answerText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
            textAlign: TextAlign.justify,
          ),
        ),
        if (imagePaths.isNotEmpty) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: 0.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 300,
                            ),
                            child: Image.asset(
                              imagePaths[index],
                              fit: BoxFit.contain,
                              height: 200,
                              colorBlendMode: BlendMode.saturation,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(SupportScreen.routeName),
          child: RichText(
            text: TextSpan(
              text: 'Still have questions? ',
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: 'Contact Support',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _FAQCategory {
  final String title;
  final List<_FAQItem> questions;

  _FAQCategory(this.title, this.questions);
}

class _FAQItem {
  final String question;
  final String answerText;
  final List<String> imagePaths;

  _FAQItem({
    required this.question,
    required this.answerText,
    this.imagePaths = const [],
  });
}

// Example FAQ data
final List<_FAQCategory> _faqCategories = [
  _FAQCategory('General Information', [
    _FAQItem(
      question: 'What is the purpose of the app?',
      answerText:
          'The app helps streamline parking at FPT University Ho Chi Minh Campus, making payments quicker and more efficient.',
      imagePaths: [AssetHelper.banner3],
    ),
    _FAQItem(
      question: 'How can I create an account?',
      answerText: 'Click on "Continue with Google" to create your account.',
      imagePaths: [AssetHelper.loginScreen],
    ),
    _FAQItem(
      question: 'Is the app free to use?',
      answerText:
          'Yes, it\'s free, and we\'ll inform you of any future changes.',
      imagePaths: [],
    ),
  ]),
  _FAQCategory('Parking Features', [
    _FAQItem(
      question: 'How do I pay for parking?',
      answerText:
          'You can pay via your in-app e-wallet or at the exit gate. Topping up your e-wallet ensures a quicker checkout.',
      imagePaths: [AssetHelper.walletScreen],
    ),
    _FAQItem(
      question: 'What should I do if I encounter an issue with parking?',
      answerText: 'Contact us through the Support or at the parking lot.',
      imagePaths: [AssetHelper.supportScreen],
    ),
  ]),
  _FAQCategory('E-Wallet and Payments', [
    _FAQItem(
      question: 'How do I top up my e-wallet?',
      answerText:
          'Use ZaloPay, or ATM, Internet Banking, international cards via VnPay Gateway',
      imagePaths: [
        AssetHelper.fundInScreen,
        AssetHelper.payMethodScreen,
      ],
    ),
    _FAQItem(
      question: 'How do I pay for parking using the e-wallet?',
      answerText:
          'When you exit the parking lot, the system will automatically deduct the parking fee from your e-wallet balance.',
      imagePaths: [],
    ),
    _FAQItem(
      question: 'Which domestic banks are supported for e-wallet top-ups?',
      answerText:
          'We support various domestic banks  via VnPay Gateway for e-wallet top-ups, please check more details in VnPay',
      imagePaths: [AssetHelper.patnerAtm],
    ),
    _FAQItem(
      question: 'Which international cards are supported for e-wallet top-ups?',
      answerText:
          '''You can top up your e-wallet using international cards via VnPay Gateway. Supported international cards include:

  - MasterCard
  - JCB
  - AMEX (American Express)
  - UniPay

  Please check more details in VnPay.''',
      imagePaths: [AssetHelper.partnerCard],
    ),
    _FAQItem(
      question: 'What is the benefit of using the e-wallet?',
      answerText:
          'It\'s faster, more convenient, and reduces cash usage. It also helps to save the environment too.',
      imagePaths: [],
    ),
    _FAQItem(
      question: 'Can I link my bank account to the e-wallet?',
      answerText: 'Not yet, but we plan to add this feature soon.',
      imagePaths: [],
    ),
    _FAQItem(
      question: 'What should I do if a payment fails?',
      answerText:
          'Retry if not charged, or contact Support if payment was deducted.',
      imagePaths: [],
    ),
    _FAQItem(
      question: 'Are there any fees for using the e-wallet?',
      answerText: 'Possible fees may apply from payment gateways or banks.',
      imagePaths: [],
    ),
  ]),
  _FAQCategory('Cashless Hero System', [
    _FAQItem(
      question: 'What is the Cashless Hero system?',
      answerText:
          'The system encourages customers to reduce cash usage by tracking how often they use the in-app e-wallet. Non-e-wallet payments are considered "cash" transactions.',
      imagePaths: [],
    ),
    _FAQItem(
      question: 'How can I become a Cashless Hero?',
      answerText:
          'Use the in-app wallet regularly to reach different Hero levels based on your cashless transactions and their ratio to cash payments.',
      imagePaths: [],
    ),
    _FAQItem(
      question: 'What are the different levels in the Cashless Hero system?',
      answerText: 'The levels are:\n'
          '- Hero 0: Cashless Starter – Default for all users\n'
          '- Hero 1: Cashless Explorer\n'
          '- Hero 2: Cashless Adventurer\n'
          '- Hero 3: Cashless Champion\n'
          '- Hero 4: Cashless Master',
      imagePaths: [],
    ),
  ]),
  _FAQCategory('Account and Security', [
    _FAQItem(
      question: 'How can I reset my password?',
      answerText: 'Use Google\'s password recovery process.',
      imagePaths: [],
    ),
    _FAQItem(
      question: 'What should I do if I lose my phone?',
      answerText: 'You can log in on another device without issue.',
      imagePaths: [],
    ),
    _FAQItem(
      question: 'How can I update my account information?',
      answerText: 'Currently, you can only update your display name.',
      imagePaths: [],
    ),
  ]),
  _FAQCategory('Technical Issues', [
    _FAQItem(
      question: 'The app is not working properly. What should I do?',
      answerText:
          'Check your internet connection, update the app, or contact Support.',
      imagePaths: [],
    ),
    _FAQItem(
      question: 'Why can\'t I log in to my account?',
      answerText:
          'Ensure your Google account is active or contact Support if your account was banned.',
      imagePaths: [],
    ),
  ]),
];
