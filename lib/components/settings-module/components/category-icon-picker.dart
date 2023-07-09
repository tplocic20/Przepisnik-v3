import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:styled_widget/styled_widget.dart';

import 'category-tile-preview.dart';

const icons = [
  'almond',
  'apple',
  'artichoke',
  'asparagus',
  'avocado',
  'basil',
  'bay-leaf',
  'birthday-cake',
  'blueberry',
  'bonsai',
  'bread',
  'brezel',
  'cake',
  'campfire',
  'carrot',
  'cat',
  'cauliflower',
  'cheese',
  'chef-hat',
  'cherry',
  'chocolate-bar',
  'citrus',
  'cocktail',
  'coconut',
  'coffee-beans',
  'cooker',
  'cookie',
  'corn',
  'crab',
  'croissant',
  'cucumber',
  'cupcake',
  'dining-room',
  'doughnut',
  'dragon-fruit',
  'dry',
  'eggs',
  'favorite',
  'food-and-wine',
  'food',
  'french-fries',
  'french-press',
  'fridge',
  'garlic',
  'gingerbread-house',
  'gingerbread-man',
  'grapes',
  'hamburger',
  'hot-chocolate-with-marshmallows',
  'hot-dog',
  'hot-springs',
  'ice-cream-cone',
  'ice-cream-sundae',
  'ingredients',
  'kebab',
  'kiwi',
  'leek',
  'lemonade',
  'lettuce',
  'mango',
  'mate',
  'melon',
  'mint',
  'moka-pot',
  'mulled-wine',
  'mushroom',
  'natural-food',
  'noodles',
  'nut',
  'octopus',
  'olive-oil',
  'olive',
  'orange',
  'pancake-stack',
  'papaya',
  'paprika',
  'parsley',
  'peach',
  'peanuts',
  'pear',
  'peas',
  'pineapple',
  'pizza',
  'pomegranate',
  'porridge',
  'potato',
  'pumpkin',
  'rack-of-lamb',
  'radish',
  'raspberry',
  'restaurant',
  'rice-bowl',
  'salmon-sushi',
  'soda-water',
  'soursop',
  'soy',
  'squash',
  'steak',
  'strawberry',
  'sunny-side-up-eggs',
  'sushi',
  'sweet-potato',
  'tableware',
  'taco',
  'tangelo',
  'tea-cup',
  'tea',
  'thanksgiving',
  'thyme',
  'tomato',
  'tropics',
  'vegan-food',
  'vegetarian-food',
  'watermelon',
  'weber',
  'wheat',
  'whole-fish',
  'wooden-beer-keg'
];

class CategoryIconPicker extends StatefulWidget {
  final String? current;
  final String? name;
  final Color? color;
  final Function? onChanged;

  const CategoryIconPicker(
      {this.current,
      @required this.name,
      @required this.color,
      @required this.onChanged});

  @override
  State<CategoryIconPicker> createState() => _CategoryIconPickerState();
}

class _CategoryIconPickerState extends State<CategoryIconPicker> {
  String selected = 'dining-room';

  @override
  void initState() {
    this.selected = widget.current ?? 'dining-room';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CategoryTilePreview(
            selectedIcon: this.selected,
            name: widget.name!,
            selectedColor: widget.color!,
            mode: CategoryTilePreviewMode.iconColor),
        Expanded(
            child: SingleChildScrollView(
          child: Wrap(
            children: icons
                .map((image) => TextButton(
                        onPressed: () {
                          setState(() {
                            this.selected = image;
                            widget.onChanged!(image);
                          });
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: this.selected == image
                                ? Colors.grey.shade200
                                : Colors.transparent),
                        child: SvgPicture.asset(
                            'assets/category_icons/$image.svg',
                            height: 55,
                            width: 55))
                    .clipRRect(all: 15)
                    .padding(all: 10))
                .toList(),
          ),
        ))
      ],
    );
  }
}
