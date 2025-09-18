import 'package:flutter/material.dart';

import '../../service/open_service.dart';

class BioData extends StatelessWidget {
  const BioData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 24,
        title: const Text(
          'Arijit Sarkar',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            _buildProfileCard(),
            const SizedBox(height: 20),

            // Contact Card
            _buildContactCard(),
            const SizedBox(height: 20),

            // Employment History
            _buildEmploymentCard(),

            // Education Card
            const SizedBox(height: 20),
            _buildEducationCard(),

            // Skills Card
            const SizedBox(height: 20),
            _buildSkillsCard(),

            // Languages & Hobbies Card
            const SizedBox(height: 20),
            _buildLanguagesHobbiesCard(),

            // Courses Card
            const SizedBox(height: 20),
            _buildCoursesCard(),

            // Projects Card
            const SizedBox(height: 20),
            _buildProjectsCard(),

            // Add a spacer at the end
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEmploymentCard() {
    return Card(
      elevation: 3,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE74C3C).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.work,
                    color: Color(0xFFE74C3C),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Employment History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildJobEntry(
              'Mar 2023 - Present',
              'App Developer',
              'SastaSundar, Kolkata',
              'App & Web Developer (Flutter), specializing in crafting seamless cross-platform solutions. With expertise in Dart and JS, seamlessly integrates BLOC for state management and ensures flawless payment integration with PhonePe and Paytm.',
            ),
            const SizedBox(height: 16),
            _buildJobEntry(
              'May 2022 - Mar 2023',
              'Software Engineer (Flutter Developer)',
              'Max mobility, Kolkata',
              'Skilled in Dart, crafting cross-platform apps. Proficient in BLoC & GetX state management, integrating location tracking & local DB for robust solutions.',
            ),
            const SizedBox(height: 16),
            _buildJobEntry(
              'Oct 2021 - Apr 2022',
              'Flutter Developer',
              'SOFTWEBIAN',
              'Specialize in crafting cross-platform apps with Dart. Proficient in UI/UX, GetX state management & API integration.',
            ),
            const SizedBox(height: 16),
            _buildJobEntry(
              'Nov 2020 - May 2021',
              'Trainee Android and Flutter Developer',
              'MOBILOITTE, New Delhi',
              'Mastering Java, Kotlin, Dart & Flutter for cross-platform apps.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobEntry(
      String period, String title, String company, String description) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF3498DB).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              period,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF3498DB),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            company,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 3,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3498DB).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF3498DB),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'PROFILE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Skilled Flutter developer with 3+ years exp. Specialize in BLOC, Provider, GetX. Proficient in Dart, UI/UX, location tracking, & payment integration (PhonePe, Paytm, etc.). Dedicated to excellence & innovation.',
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.white70,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Card(
      elevation: 3,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE74C3C).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.contact_page,
                    color: Color(0xFFE74C3C),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'CONTACT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildContactRow(Icons.location_on, 'Kolkata, India'),
            const SizedBox(height: 12),
            _buildContactRow(Icons.phone, '+91 89189 51655'),
            const SizedBox(height: 12),
            _buildContactRow(Icons.email, 'ruarijitsarkar@gmail.com'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF3498DB),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationCard() {
    return Card(
      elevation: 3,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B59B6).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Color(0xFF9B59B6),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'EDUCATION',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildEducationRow('2017-2021',
                'B. Tech (E.C.E), University of Engineering & Management (UEM), Jaipur'),
            const SizedBox(height: 12),
            _buildEducationRow(
                '2017', 'Higher Secondary, Panchgram High School'),
            const SizedBox(height: 12),
            _buildEducationRow('2015', 'Secondary, Panchgram High School'),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationRow(String period, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            period,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF3498DB),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsCard() {
    return Card(
      elevation: 3,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF39C12).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.code,
                    color: Color(0xFFF39C12),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'SKILLS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                _buildSkillChip('Flutter (Expert)', const Color(0xFF3498DB)),
                _buildSkillChip('Node.js (Expert)', const Color(0xFF27AE60)),
                _buildSkillChip('Git (Expert)', const Color(0xFFE74C3C)),
                _buildSkillChip(
                    'Microsoft Office (Expert)', const Color(0xFFF39C12)),
                _buildSkillChip(
                    'JavaScript (Skillful)', const Color(0xFF9B59B6)),
                _buildSkillChip('Java (Skillful)', const Color(0xFF34495E)),
                _buildSkillChip('MySQL (Skillful)', const Color(0xFF16A085)),
                _buildSkillChip('SQL (Skillful)', const Color(0xFF8E44AD)),
                _buildSkillChip(
                    'Python (Experienced)', const Color(0xFF2980B9)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String label, Color color) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: BorderSide(color: color.withOpacity(0.3), width: 1),
    );
  }

  Widget _buildLanguagesHobbiesCard() {
    return Card(
      elevation: 3,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF27AE60).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.language,
                          color: Color(0xFF27AE60),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'LANGUAGES',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.only(left: 32.0),
                    child: Text(
                      'English - Highly proficient',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE67E22).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sports_esports,
                          color: Color(0xFFE67E22),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'HOBBIES',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.only(left: 32.0),
                    child: Text(
                      'Cycling, listening music',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesCard() {
    return Card(
      elevation: 3,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8E44AD).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.menu_book,
                    color: Color(0xFF8E44AD),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'COURSES & CERTIFICATIONS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCourseItem(
                'Back-end development (Rest API with node js and MongoDB)',
                'Udemy and online material'),
            const SizedBox(height: 12),
            _buildCourseItem('Java vocational training', 'MSME'),
            const SizedBox(height: 12),
            _buildCourseItem('VLSI vocational training', 'MSME'),
            const SizedBox(height: 12),
            _buildCourseItem(
                'Bsnl vocational training for overall telecommunication system',
                'Bsnl'),
            const SizedBox(height: 12),
            _buildCourseItem('Machine Learning with Python', 'MYWBUT'),
            const SizedBox(height: 12),
            _buildCourseItem('Python Programming Language', 'MYWBUT'),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseItem(String title, String provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        Text(
          provider,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectsCard() {
    return Card(
      elevation: 3,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE74C3C).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.architecture_rounded,
                    color: Color(0xFFE74C3C),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'PROJECTS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProjectItem(
              'Age and gender recognition',
              'Developed accurate age and gender recognition systems using advanced Python algorithms. Integrated solutions into various applications for improved user experience.',
            ),
            const SizedBox(height: 12),
            _buildProjectItem(
              'Food Frenzy',
              'I developed Food Frenzy, a restaurant management app facilitating order food and streamlining order management.',
            ),
            const SizedBox(height: 12),
            _buildProjectItem(
              'Caretaker',
              'Developed a comprehensive home service app, featuring home and car cleaning services. Emphasized user convenience and safety for seamless independent living experiences.',
            ),
            const SizedBox(height: 12),
            _buildProjectItemWithLinks(
              'Imanage',
              'Self-care app of tata for bill payment and manage inventory of multiple products.',
              [
                _buildProjectLink('Android App',
                    'https://play.google.com/store/apps/details?id=com.tatatele.imanageappprod'),
                _buildProjectLink('iOS App',
                    'https://apps.apple.com/in/app/tata-tele-imanage/id1613502566'),
              ],
            ),
            const SizedBox(height: 12),
            _buildProjectItemWithLinks(
              'Tata Wfm',
              'I developed Tata WFM app, optimizing workforce management. Collaborating with clients, I ensured efficient processes, productivity, and quality. My work improved scheduling, resource allocation, and employee engagement.',
              [
                _buildProjectLink('Android App',
                    'https://play.google.com/store/apps/details?id=com.ttsl.wfm'),
              ],
            ),
            const SizedBox(height: 12),
            _buildProjectItem(
              'Tata Combing',
              'Led development of Tata Combing App for office maintenance. Streamlined monitoring of maintenance schedules and occupancy levels. Optimized office management for Tata establishments.',
            ),
            const SizedBox(height: 12),
            _buildProjectItem(
              'Gotrakk',
              'I developed Gotrakk, a vehicle tracking system enabling real-time tracking and fleet optimization. Collaborated on seamless integration and user-friendly design. Aimed to revolutionize fleet operations for enhanced efficiency.',
            ),
            const SizedBox(height: 12),
            _buildProjectItem(
              'Gemopai Connect',
              'I developed Gemopai Connect, a vehicle tracking system enabling real-time tracking and fleet optimization. Collaborated on seamless integration and user-friendly design to revolutionize fleet operations for enhanced efficiency.',
            ),
            const SizedBox(height: 12),
            _buildProjectItemWithLinks(
              'Jivanjor Smart Connect',
              'I developed Jivanjor Smart Connect App for JACPL dealers. Simplified order placement and product info access, enhancing operational efficiency.',
              [
                _buildProjectLink('Android App',
                    'https://play.google.com/store/apps/details?id=com.maxmobility.smart_connect'),
                _buildProjectLink('iOS App',
                    'https://apps.apple.com/us/app/jivanjor-smart-connect/id1609917902'),
              ],
            ),
            const SizedBox(height: 12),
            _buildProjectItem(
              'MCSS Staffing solutions',
              'I developed an employee management app, streamlining tasks like scheduling shifts, tracking work hours, and facilitating communication among team members. Designed for simplicity and efficiency in managing staff.',
            ),
            const SizedBox(height: 12),
            _buildProjectItemWithLinks(
              'Retailer Shakti',
              'I developed Retailer Shakti, a retail management system featuring a mobile app and m-site. Streamlines inventory, sales, and customer management for retailers.',
              [
                _buildProjectLink('Android App',
                    'https://play.google.com/store/apps/details?id=com.retailershakti'),
                _buildProjectLink('iOS App',
                    'https://apps.apple.com/in/app/retailershakti-wholesale-app/id6448796029'),
                _buildProjectLink('M-Site', 'https://www.retailershakti.com/'),
              ],
            ),
            const SizedBox(height: 12),
            _buildProjectItemWithLinks(
              'Genu Path Labs',
              'I developed Genu Path Labs, a healthcare platform with a mobile app and m-site, offering video calls, lab management, patient tracking, and report generation. Streamlined workflows and enhanced patient care while ensuring healthcare compliance.',
              [
                _buildProjectLink('Android App',
                    'https://play.google.com/store/apps/details?id=com.genupathlabs'),
                _buildProjectLink('iOS App',
                    'https://apps.apple.com/us/app/genu-health/id6483367005'),
                _buildProjectLink('M-Site', 'https://www.genupathlabs.com/'),
              ],
            ),
            const SizedBox(height: 12),
            _buildProjectItemWithLinks(
              'SastaSundar',
              'I developed SastaSundar, a medical e-commerce platform with a mobile app, m-site, and video consultation. Streamlined medicine orders, diagnostic bookings, and healthcare services, ensuring compliance and efficiency.',
              [
                _buildProjectLink('Android App',
                    'https://play.google.com/store/apps/details?id=com.shtpl.sastasundar'),
                _buildProjectLink('iOS App',
                    'https://apps.apple.com/in/app/sastasundar-online-pharmacy/id6738185605'),
                _buildProjectLink('M-Site', 'https://sastasundar.com/'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectItem(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectItemWithLinks(
      String title, String description, List<Widget> links) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: links,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectLink(String text, String url) {
    return GestureDetector(
      onTap: () {
        OpenService.openUrl(uri: Uri.parse(url));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF3498DB).withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFF3498DB).withOpacity(0.5)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF3498DB),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
