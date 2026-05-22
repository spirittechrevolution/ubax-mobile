import 'package:flutter/material.dart';
import 'package:statefulclickcounter/core/network/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_flags/country_flags.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:statefulclickcounter/features/auth/domain/repositories/auth_repository.dart';
import 'package:statefulclickcounter/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:statefulclickcounter/features/auth/widgets/africa_country_code_picker.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';
import 'package:statefulclickcounter/theme/app_text_styles.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final currentUser = context.read<AuthBloc>().state.currentUser;
    if (currentUser != null) {
      _nameController.text = currentUser.fullName;
      _emailController.text = currentUser.email ?? '';
      _phoneController.text = currentUser.phone ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galerie'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickAndUploadAvatar(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Caméra'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickAndUploadAvatar(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndUploadAvatar(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload de l\'avatar en cours...')),
          );
        }

        // Upload the avatar using the repository
        final authRepository = GetIt.instance<AuthRepository>();
        await authRepository.uploadAvatar(image.path);

        // Refresh the user profile
        if (mounted) {
          context.read<AuthBloc>().add(const AuthProfileRefreshed());
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Avatar mis à jour avec succès !')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppErrors.translate(e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar
            Padding(
              padding: EdgeInsets.fromLTRB(14, topPadding + 10, 14, 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.dark, size: 20),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Profil',
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontFamily: 'Lexend',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),

            // ── Avatar + Modifier
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final currentUser = state.currentUser;
                final rawUrl = currentUser?.avatarUrl;
                final hasUrl = rawUrl != null && rawUrl.trim().isNotEmpty;
                final cacheKey =
                    (currentUser?.updatedAt ?? currentUser?.userId ?? '');
                final cacheBustedUrl = hasUrl
                    ? (rawUrl.contains('?')
                        ? '$rawUrl&v=$cacheKey'
                        : '$rawUrl?v=$cacheKey')
                    : null;
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipOval(
                            child: hasUrl
                                ? Image.network(
                                    cacheBustedUrl!,
                                    key: ValueKey<String>(cacheBustedUrl),
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 90,
                                      height: 90,
                                      color: AppColors.dark,
                                      child: const Icon(Icons.person,
                                          color: Colors.white, size: 40),
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/pexels-ekrulila-2128329.jpg',
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 90,
                                      height: 90,
                                      color: AppColors.dark,
                                      child: const Icon(Icons.person,
                                          color: Colors.white, size: 40),
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: -5,
                            right: -5,
                            child: GestureDetector(
                              onTap: _showImageSourceDialog,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: Text(
                          'Modifier',
                          style: AppTextStyles.regular12.copyWith(
                            fontFamily: 'Lexend',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 18),

            // ── Form card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 430,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _Label(text: 'Nom'),
                    const SizedBox(height: 8),
                    _PillField(controller: _nameController),
                    const SizedBox(height: 20),
                    _Label(text: 'Email'),
                    const SizedBox(height: 6),
                    _PillField(controller: _emailController),
                    const SizedBox(height: 20),
                    _Label(text: 'Numéro de téléphone'),
                    const SizedBox(height: 6),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final user = state.currentUser;
                        final country = AfricaCountryCodePicker.fromUser(
                          phone: user?.phone,
                          country: user?.country,
                        );
                        return Row(
                          children: [
                            Container(
                              width: 110,
                              height: 52,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECF2F7),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipOval(
                                    child: CountryFlag.fromCountryCode(
                                      country.iso2,
                                      width: 26,
                                      height: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    country.dialCode,
                                    style: AppTextStyles.regularlight16
                                        .copyWith(
                                      fontFamily: 'Lexend',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.text,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.dark,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _PillField(controller: _phoneController),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _Label(text: 'Documents d\'identité'),
                    const SizedBox(height: 6),
                    Container(
                      height: 52,
                      padding: const EdgeInsets.only(left: 18, right: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECF2F7),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Téléverser vos documents',
                              style: AppTextStyles.regularlight16.copyWith(
                                fontFamily: 'Lexend',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.upload_rounded,
                                color: AppColors.dark, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ── Update button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Mettre à jour',
                    style: AppTextStyles.button.copyWith(
                      fontFamily: 'Lexend',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.regular12.copyWith(
        fontFamily: 'Lexend',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
      ),
    );
  }
}

class _PillField extends StatelessWidget {
  const _PillField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFECF2F7),
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        style: AppTextStyles.regularlight16.copyWith(
          fontFamily: 'Lexend',
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.text,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
