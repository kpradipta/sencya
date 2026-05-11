import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class ClientDirectoryPage extends StatelessWidget {
  const ClientDirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 48),
              _buildHeader(),
              _buildSearchSection(),
              Expanded(
                child: _buildClientList(),
              ),
              const SizedBox(height: 80), // Space for nav bar
            ],
          ),
          Positioned(
            bottom: 100,
            right: 24,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColors.primaryRed,
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAxZ4NbMnjU_eqrgHzw5IWn3akXyP3Sa0YeMiAP9bInqCJf7h1ZonKHpEPOAKzTIzBI2SHBCY2KwQDW2f8TAtXeofQBGA_EHEnrjl1cR0msxpmkIcVZDu_0vnEmnCAE1jv3px7UziUGAmsKV1ukZedpRDjZ1V2Lihf9GSUMNjrzejCt0YMKzlCbRBtLkcqUPV1CUwLgfeVsu9EeYOIn249neyjBDRK0e5UMoskxIczF9Ec3lZSL1ppQZg_Zi7PAAYdDQxp7NjYliisk'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Text('Client Directory', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 22),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: Colors.orange, size: 14),
                SizedBox(width: 8),
                Text('CLIENT DIRECTORY API COMING SOON', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ],
            ),
          ),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search by name, service, or notes...',
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.white24, size: 20),
              filled: true,
              fillColor: AppColors.surfaceDark,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All Clients', true),
                const SizedBox(width: 8),
                _buildFilterChip('Recent', false),
                const SizedBox(width: 8),
                _buildFilterChip('Top Spend', false),
                const SizedBox(width: 8),
                _buildFilterChip('Follow-up', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryRed : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white38,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildClientList() {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            _buildAlphaDivider('M'),
            _buildClientCard(
              'Marcus Thompson',
              'Oct 12',
              ['SKIN FADE', 'BEARD TRIM'],
              'Lakers fan. Prefers low taper. Keep it short on top.',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAGf1tqa8fQW1w9BOwct0lqIGhjzblMcn-i1ffJylENJVZDqnFHLOWA0IFYIifNEfnoZQJ1nRySnNZtPr5e0-2q1JPU3hnxE_sSXyGsNhNcJEv2bGdbFEd_Q4oz7vWqxbCaiTV6RY2ZfENYMbuYMNgCUg3XoN-YPYJ3S2Y8cWQR94ivcNxFLEPwqeSmviSKz4rAK2xUsIZMToChtyIJbNgDg-EYhG_U2OAKeq3frb32cuubtjxtMpgAU8rtqzb6Py67qG6vUi3RxDG8',
            ),
            const SizedBox(height: 12),
            _buildClientCard(
              'Michael Ross',
              'Oct 09',
              ['BUZZ CUT'],
              'Corporate lawyer. Always in a hurry. Morning appts only.',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBmi4GGSLyEYGhNBCxCgyBsMGkRCyklYQPaAQiUpl9YcPxvJdElSwwrhp2AlrEz8luPXfxAgeSjfFoCa10J6G3NVUXn2FLqzBLkCVjSXEqwrrMWc1D3pU_BQLVMQUlcXs33PVYxzNQJY2lz1DPn0aJg_Z1f2vhEMPpDUDh8gKl1H6ySyfuSyfPtt6pv5E_d4eTsTQ5X3tkgy1Jdg82RvOXwPOjZVJQY5PJEFEM_yeLreUsYRED2ct3_gNlRt2kIN8_Ps2GP1GohlbRK',
            ),
            _buildAlphaDivider('S'),
            _buildClientCard(
              'Steven Zhang',
              'Yesterday',
              ['SCISSOR CUT', 'HOT TOWEL'],
              'Prefers quiet service. Lives in Brooklyn. No product.',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAPEiJnqZavtX9ZJceq-cZ4_xhuPV0S9cB4lWs5IQxWGNqx8kK6swLwnU6hzU2AxxdzU0gzKidlcOWj3NTB0Q827iBNuES1FQE1KN3G3LfYu1PGJ6-aKcWPkMLlscKlaS_lFlokfGB_WCMSR7hlZ38zJNdQO_rnIhWT5g8lrDofWwhGe1xTxALuJcEg3D5eQPDPGDxg7Fx1FOCzqdLkx7kWcSUpQQacN3T9moZv_xi8_aYHkH-OqlM459FI7r310-DPDofa6LqGrbVv',
            ),
            const SizedBox(height: 12),
             _buildClientCard(
              'Samuel Rivera',
              'Sep 28',
              ['MULLET', 'DESIGN'],
              'Graphic designer. Experimental cuts. Likes patterns.',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBYwyYrDwwyAAmRQNc3NyLLbA9oErMJou74tYLOmPZIOSebdeQKWO6bBlxGKpUbiktnG8JFva38JOu5zlS9XiSWt0sqm9s41RaVQHU_b9-t8p6EiLp6DkHWTb5WGKtvo5TuiHPpeStQeW_jbpm8zJcvS8NvL-xVJ5oKPaHUa6-NfxNNJnOnM6xqEYvVtZ81rwyG-4rTp7TdoKBRIv6V_YaFFBxufa_5fs-2xLBNWHQzq0urOWhvm-qRkcEC0koeEuN1kpCjebnFDNhp',
            ),
          ],
        ),
        // Alphabet Scroller placeholder (right side)
        Positioned(
          right: 4,
          top: 0,
          bottom: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((char) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(char, style: const TextStyle(color: AppColors.primaryRed, fontSize: 9, fontWeight: FontWeight.bold)),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAlphaDivider(String char) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(char, style: const TextStyle(color: Colors.white24, fontSize: 12, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildClientCard(String name, String date, List<String> tags, String note, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(date.toUpperCase(), style: const TextStyle(color: AppColors.primaryRed, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: tag == tags.first ? AppColors.primaryRed.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(tag, style: TextStyle(color: tag == tags.first ? AppColors.primaryRed : Colors.white38, fontSize: 9, fontWeight: FontWeight.w900)),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  '"$note"',
                  style: const TextStyle(color: Colors.white38, fontSize: 12, fontStyle: FontStyle.italic),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
