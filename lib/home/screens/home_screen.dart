import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:wardrobe/common/utils/apiUtils.dart';
import 'package:wardrobe/home/screens/clothes_screen.dart';
import 'package:wardrobe/home/screens/drawer_screen.dart';
import 'package:wardrobe/home/screens/outfits_screen.dart';
import 'package:wardrobe/home/screens/settings_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text(
          'Smart Wardrobe',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: FutureBuilder(
              future: ApiService.getWeatherData(40.9693181, 14.2054889),
              builder: (context, weatherSnapshot) {
                var weatherData = weatherSnapshot.data!;
                bool isSnowing = weatherData["current"]["snowfall"] > 0.1;
                bool isSunny = weatherData["current"]["precipitation"] <= 0.1 &&
                    weatherData["current"]["showers"] <= 0.1 &&
                    weatherData["current"]["rain"] <= 0.1;

                if (weatherSnapshot.hasData) {
                  return ListTile(
                    leading: Image.asset(isSunny
                        ? (isSnowing
                            ? 'lib/assets/icons/snow.png'
                            : 'lib/assets/icons/clear-sky.png')
                        : 'lib/assets/icons/rain.png'),
                    title: Text(
                      '${weatherData['current']['temperature_2m']} ${weatherData['current_units']['temperature_2m']}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    subtitle: Text(
                      '${weatherData['current']['relative_humidity_2m']} ${weatherData['current_units']['relative_humidity_2m']}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    trailing: Icon(Icons.cloud),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ResponsiveGridView(
                children: [
                  HomeScreenTile(
                    icon: Icons.checkroom,
                    title: 'Clothes',
                    page: ClothingListPage(),
                  ),
                  HomeScreenTile(
                    icon: Icons.room_preferences,
                    title: 'Outfits',
                    page: OutfitListPage(),
                  ),
                  HomeScreenTile(
                    icon: Icons.density_small_outlined,
                    title: 'Drawers',
                    page: DrawerScreen(),
                  ),
                  HomeScreenTile(
                    icon: Icons.settings,
                    title: 'Settings',
                    page: SettingsPage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreenTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget page;

  const HomeScreenTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        title: Center(
          child: AutoSizeText(
            title,
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return page;
            },
          ));
        },
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(50),
              bottomEnd: Radius.circular(50),
              topEnd: Radius.circular(10),
              bottomStart: Radius.circular(10),
            ),
          ),
          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(200),
          child: LayoutBuilder(builder: (context, constraint) {
            return Center(
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.onBackground,
                size: constraint.maxHeight / 3,
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveGridView({Key? key, required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = 2;
    if (width > 600) {
      crossAxisCount = 3;
    }
    if (width > 900) {
      crossAxisCount = 4;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
    );
  }
}
