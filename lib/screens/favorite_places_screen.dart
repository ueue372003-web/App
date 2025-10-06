// lib/screens/favorite_places_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lnmq/models/place_model.dart';
import 'package:lnmq/models/user_model.dart'; 
import 'package:lnmq/services/auth_service.dart';
import 'package:lnmq/services/place_service.dart';
import 'package:lnmq/services/user_service.dart';
import 'package:lnmq/widgets/place_card.dart';
import 'package:lnmq/l10n/app_localizations.dart';

class FavoritePlacesScreen extends StatefulWidget {
  const FavoritePlacesScreen({super.key});

  @override
  State<FavoritePlacesScreen> createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends State<FavoritePlacesScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final PlaceService _placeService = PlaceService();

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.getCurrentUser();
    if (_currentUser == null) {
      Future.microtask(() {
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (_currentUser == null) {
      // Show loading while redirecting
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                localizations.favoriteCategory,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<AppUser?>(
                stream: _userService.getUserData(_currentUser!.uid),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (userSnapshot.hasError) {
                    return Center(child: Text(localizations.favoriteLoadError + userSnapshot.error.toString()));
                  }
                  if (!userSnapshot.hasData || userSnapshot.data == null) {
                    return Center(child: Text(localizations.noFavoritePlace));
                  }

                  final AppUser appUser = userSnapshot.data!;
                  final List<String> favoritePlaceIds = appUser.favoritePlaceIds;

                  if (favoritePlaceIds.isEmpty) {
                    return Center(child: Text(localizations.noFavoriteFound));
                  }

                  return FutureBuilder<List<Place>>(
                    future: _placeService.getPlacesByIds(favoritePlaceIds),
                    builder: (context, placesSnapshot) {
                      if (placesSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (placesSnapshot.hasError) {
                        return Center(child: Text(localizations.favoriteLoadError + placesSnapshot.error.toString()));
                      }
                      if (!placesSnapshot.hasData || placesSnapshot.data!.isEmpty) {
                        return Center(child: Text(localizations.noFavoriteFound));
                      }

                      final List<Place> favoritePlaces = placesSnapshot.data!;

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        itemCount: favoritePlaces.length,
                        itemBuilder: (context, index) {
                          final place = favoritePlaces[index];
                          return PlaceCard(place: place);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}