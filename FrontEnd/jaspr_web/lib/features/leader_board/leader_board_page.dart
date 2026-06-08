import 'package:jaspr/dom.dart' hide BorderRadius, Alignment;
import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;
import '../../shared/constants/theme.dart';
import '../../shared/ui/ui.dart';

class LeaderBoardPage extends StatefulComponent {
  const LeaderBoardPage({super.key});

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  final List<web.Element> _injectedElements = [];
  String? _originalTitle;

  @override
  void initState() {
    super.initState();
    _injectSeoMetadata();
  }

  @override
  void dispose() {
    _removeSeoMetadata();
    super.dispose();
  }

  void _injectSeoMetadata() {
    final head = web.document.head;
    if (head == null) return;

    _originalTitle = web.document.title;
    web.document.title = 'Health Articles, Wellness Tips & Fitness Blog | SastaSundar';

    // 1. Charset meta tag
    final charsetMeta = web.document.createElement('meta');
    charsetMeta.setAttribute('charset', 'UTF-8');
    head.appendChild(charsetMeta);
    _injectedElements.add(charsetMeta);

    // 2. Viewport meta tag
    final viewportMeta = web.document.createElement('meta');
    viewportMeta.setAttribute('name', 'viewport');
    viewportMeta.setAttribute('content', 'width=device-width, initial-scale=1.0');
    head.appendChild(viewportMeta);
    _injectedElements.add(viewportMeta);

    // 3. Description meta tag
    final descMeta = web.document.createElement('meta');
    descMeta.setAttribute('name', 'description');
    descMeta.setAttribute('content', "Explore SastaSundar's health articles for expert tips on diet, fitness, beauty, and disease prevention. Read our wellness blog for a healthier lifestyle today!");
    head.appendChild(descMeta);
    _injectedElements.add(descMeta);

    // 4. Keywords meta tag
    final keywordsMeta = web.document.createElement('meta');
    keywordsMeta.setAttribute('name', 'keywords');
    keywordsMeta.setAttribute('content', "Explore SastaSundar's health articles for expert tips on diet, fitness, beauty, and disease prevention. Read our wellness blog for a healthier lifestyle today! ");
    head.appendChild(keywordsMeta);
    _injectedElements.add(keywordsMeta);

    // 5. External stylesheet link tag
    final linkStyle = web.document.createElement('link');
    linkStyle.setAttribute('rel', 'stylesheet');
    linkStyle.setAttribute('href', 'https://sastasundar.com/assets/css/healtharticle-homepage-seo.css');
    head.appendChild(linkStyle);
    _injectedElements.add(linkStyle);

    // 6. JSON-LD schema script tag
    final scriptJsonLd = web.document.createElement('script');
    scriptJsonLd.setAttribute('type', 'application/ld+json');
    scriptJsonLd.textContent = r'''{
    "@context": "https://schema.org",
    "@graph": [
        {
            "@type": "Organization",
            "@id": "https://sastasundar.com/#organization",
            "name": "SastaSundar.com",
            "url": "https://sastasundar.com",
            "logo": {
                "@type": "ImageObject",
                "url": "https://sastasundar.com/assets/images/ss_logo.png"
            },
            "sameAs": [
                "https://www.facebook.com/SastaSundarApp/",
                "https://x.com/Sastasundarapp",
                "https://www.youtube.com/@SastaSundarApp",
                "https://www.linkedin.com/company/sastasundarapp/"
            ],
            "contactPoint": {
                "@type": "ContactPoint",
                "telephone": "+91-6289090000",
                "email": "care@sastasundar.com",
                "contactType": "customer support",
                "areaServed": "IN",
                "availableLanguage": [
                    "English",
                    "Hindi",
                    "Bengali"
                ]
            }
        },
        {
            "@type": "WebSite",
            "@id": "https://sastasundar.com/#website",
            "url": "https://sastasundar.com",
            "name": "SastaSundar.com",
            "publisher": {
                "@id": "https://sastasundar.com/#organization"
            }
        },
        {
            "@type": "BreadcrumbList",
            "@id": "https://sastasundar.com/health-article-seo#breadcrumb",
            "itemListElement": [
                {
                    "@type": "ListItem",
                    "position": 1,
                    "name": "Home",
                    "item": "https://sastasundar.com"
                },
                {
                    "@type": "ListItem",
                    "position": 2,
                    "name": "Health Articles",
                    "item": "https://sastasundar.com/health-article-seo"
                }
            ]
        },
        {
            "@type": [
                "CollectionPage",
                "MedicalWebPage"
            ],
            "@id": "https://sastasundar.com/health-article-seo#webpage",
            "url": "https://sastasundar.com/health-article-seo",
            "name": "Health Articles, Wellness Tips & Fitness Blog | SastaSundar",
            "headline": "Health Articles & Expert Wellness Tips",
            "description": "Explore SastaSundar's health articles for expert tips on diet, fitness, beauty, and disease prevention. Read our wellness blog for a healthier lifestyle today!",
            "inLanguage": "en",
            "isPartOf": {
                "@id": "https://sastasundar.com/#website"
            },
            "publisher": {
                "@id": "https://sastasundar.com/#organization"
            },
            "breadcrumb": {
                "@id": "https://sastasundar.com/health-article-seo#breadcrumb"
            },
            "primaryImageOfPage": {
                "@type": "ImageObject",
                "url": "https://sastasundar.com/assets/images/health-articles-banner.jpg"
            },
            "hasPart": [
                {
                    "@id": "https://sastasundar.com/health-article-seo#latestarticles"
                },
                {
                    "@id": "https://sastasundar.com/health-article-seo#trendingarticles"
                },
                {
                    "@id": "https://sastasundar.com/health-article-seo#browsebycategory"
                }
            ]
        },
        {
            "@type": "ItemList",
            "@id": "https://sastasundar.com/health-article-seo#latestarticles",
            "name": "Latest Health Articles",
            "itemListOrder": "https://schema.org/ItemListOrderDescending",
            "numberOfItems": 10,
            "itemListElement": [
                {
                    "@type": "ListItem",
                    "position": 1,
                    "url": "https://sastasundar.com/healtharticle/neem-leaves-benefits-for-skin-and-blood-purification"
                },
                {
                    "@type": "ListItem",
                    "position": 2,
                    "url": "https://sastasundar.com/healtharticle/cholesterol-myths-vs-facts"
                },
                {
                    "@type": "ListItem",
                    "position": 3,
                    "url": "https://sastasundar.com/healtharticle/balanced-diet-plate-for-healthy-lifestyle"
                },
                {
                    "@type": "ListItem",
                    "position": 4,
                    "url": "https://sastasundar.com/healtharticle/chickenpox-cases-symptoms-vaccine-treatment"
                },
                {
                    "@type": "ListItem",
                    "position": 5,
                    "url": "https://sastasundar.com/healtharticle/pcod-vs-pcos-what-to-know"
                },
                {
                    "@type": "ListItem",
                    "position": 6,
                    "url": "https://sastasundar.com/healtharticle/calcium-deficiency-symptoms-causes-improve-bone-health"
                },
                {
                    "@type": "ListItem",
                    "position": 7,
                    "url": "https://sastasundar.com/healtharticle/heat-rash-causes-symptoms-treatment"
                },
                {
                    "@type": "ListItem",
                    "position": 8,
                    "url": "https://sastasundar.com/healtharticle/safe-smart-travel-essentials-with-babies"
                },
                {
                    "@type": "ListItem",
                    "position": 9,
                    "url": "https://sastasundar.com/healtharticle/turmeric-benefits-immunity-inflammation"
                },
                {
                    "@type": "ListItem",
                    "position": 10,
                    "url": "https://sastasundar.com/healtharticle/gut-health-warning-signs-when-digestion-needs-help"
                }
            ]
        },
        {
            "@type": "ItemList",
            "@id": "https://sastasundar.com/health-article-seo#trendingarticles",
            "name": "Trending Health Articles",
            "itemListOrder": "https://schema.org/ItemListOrderDescending",
            "numberOfItems": 5,
            "itemListElement": [
                {
                    "@type": "ListItem",
                    "position": 1,
                    "url": "https://sastasundar.com/healtharticle/balanced-diet-plate-for-healthy-lifestyle"
                },
                {
                    "@type": "ListItem",
                    "position": 2,
                    "url": "https://sastasundar.com/healtharticle/neem-leaves-benefits-for-skin-and-blood-purification"
                },
                {
                    "@type": "ListItem",
                    "position": 3,
                    "url": "https://sastasundar.com/healtharticle/pcod-vs-pcos-what-to-know"
                },
                {
                    "@type": "ListItem",
                    "position": 4,
                    "url": "https://sastasundar.com/healtharticle/cholesterol-myths-vs-facts"
                },
                {
                    "@type": "ListItem",
                    "position": 5,
                    "url": "https://sastasundar.com/healtharticle/heat-rash-causes-symptoms-treatment"
                }
            ]
        },
        {
            "@type": "ItemList",
            "@id": "https://sastasundar.com/health-article-seo#browsebycategory",
            "name": "Browse Articles by Category",
            "itemListOrder": "https://schema.org/ItemListOrderAscending",
            "numberOfItems": 3,
            "itemListElement": [
                {
                    "@type": "ListItem",
                    "position": 1,
                    "name": "Latest Articles",
                    "url": "https://sastasundar.com/health-article-seo"
                },
                {
                    "@type": "ListItem",
                    "position": 2,
                    "name": "Trending Now",
                    "url": "https://sastasundar.com/health-article-seo"
                },
                {
                    "@type": "ListItem",
                    "position": 3,
                    "name": "Browse by Category",
                    "url": "https://sastasundar.com/health-article-seo"
                }
            ]
        }
    ]
}''';
    head.appendChild(scriptJsonLd);
    _injectedElements.add(scriptJsonLd);
  }

  void _removeSeoMetadata() {
    for (final element in _injectedElements) {
      element.remove();
    }
    _injectedElements.clear();
    if (_originalTitle != null) {
      web.document.title = _originalTitle!;
    }
  }

  final List<Map<String, dynamic>> _players = [
    {'name': 'Alex Johnson', 'score': 9850, 'rank': 1, 'icon': '🥇', 'trend': '+12'},
    {'name': 'Maria Garcia', 'score': 9420, 'rank': 2, 'icon': '🥈', 'trend': '+8'},
    {'name': 'James Wilson', 'score': 8990, 'rank': 3, 'icon': '🥉', 'trend': '+5'},
    {'name': 'Sarah Chen', 'score': 8750, 'rank': 4, 'icon': '4', 'trend': '+3'},
    {'name': 'David Kim', 'score': 8340, 'rank': 5, 'icon': '5', 'trend': '-2'},
    {'name': 'Emily Brown', 'score': 7980, 'rank': 6, 'icon': '6', 'trend': '+1'},
    {'name': 'Michael Lee', 'score': 7650, 'rank': 7, 'icon': '7', 'trend': '+4'},
    {'name': 'Lisa Wang', 'score': 7320, 'rank': 8, 'icon': '8', 'trend': '-1'},
    {'name': 'Robert Taylor', 'score': 6990, 'rank': 9, 'icon': '9', 'trend': '+2'},
    {'name': 'Amy Martinez', 'score': 6670, 'rank': 10, 'icon': '10', 'trend': '+6'},
  ];

  @override
  Component build(BuildContext context) {
    return Column(
      gap: 24,
      children: [

        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText('🏆 Leader Board', variant: TextVariant.h2),
                CustomText('Top performers this season', variant: TextVariant.bodySmall),
              ],
            ),
            CustomButton(
              label: 'Refresh',
              icon: '🔄',
              onPressed: () {
                setState(() {});
              },
            ),
          ],
        ),

        // Stats overview grid
        GridView(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          children: [
            _statCard('🏆', 'Active Season', 'Season 10'),
            _statCard('👥', 'Total Players', '1,234'),
            _statCard('💰', 'Prize Pool', '\$5,000'),
          ],
        ),

        // Top 3 podium
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          gap: 16,
          className: 'podium',
          children: [
            _podiumCard(_players[1], 'silver'),
            _podiumCard(_players[0], 'gold'),
            _podiumCard(_players[2], 'bronze'),
          ],
        ),

        // Full ranking list
        Card(
          className: 'ranking-card',
          padding: const EdgeInsets.all(20.0),
          borderRadius: const BorderRadius.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                className: 'ranking-header',
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText('#', className: 'rh-rank', variant: TextVariant.label),
                    CustomText('Player', className: 'rh-name', variant: TextVariant.label),
                    CustomText('Score', className: 'rh-score', variant: TextVariant.label),
                    CustomText('Trend', className: 'rh-trend', variant: TextVariant.label),
                  ],
                ),
              ),
              ListView.separated(
                itemCount: _players.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => _rankRow(_players[index]),
                separatorBuilder: (context, index) => const CustomDivider(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Component _statCard(String icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: 12,
      children: [
        Container(
          className: 'lb-stat-icon',
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(12.0),
          ),
          child: CustomText(icon, variant: TextVariant.h3),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(label, variant: TextVariant.bodySmall, color: secondaryDark),
            CustomText(value, variant: TextVariant.h3, fontWeight: FontWeight.w700),
          ],
        ),
      ],
    );
  }

  Component _podiumCard(Map<String, dynamic> player, String tier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      className: 'podium-card podium-$tier',
      gap: 8,
      children: [
        CustomText(player['icon'] as String, className: 'podium-medal', variant: TextVariant.h1),
        CustomText(player['name'] as String, variant: TextVariant.body, fontWeight: FontWeight.w600),
        CustomText('${player['score']} pts', variant: TextVariant.bodySmall, color: secondaryDark),
      ],
    );
  }

  Component _rankRow(Map<String, dynamic> player) {
    final rank = player['rank'] as int;
    final isTop3 = rank <= 3;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      className: 'rank-row ${isTop3 ? "rank-top" : ""}',
      children: [
        CustomText('${player['rank']}', className: 'rank-num', fontWeight: FontWeight.w700),
        Container(
          className: 'rank-avatar',
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(18.0),
          ),
          child: CustomText(((player['name'] as String)[0]), fontWeight: FontWeight.w600, color: Colors.white),
        ),
        CustomText(player['name'] as String, className: 'rank-name', fontWeight: FontWeight.w500),
        CustomText('${player['score']}', className: 'rank-score', fontWeight: FontWeight.w600),
        CustomText(
          player['trend'] as String,
          className: 'rank-trend ${(player['trend'] as String).startsWith('+') ? "trend-up" : "trend-down"}',
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
