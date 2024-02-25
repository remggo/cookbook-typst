#import "cookbook.typ": recipe_yaml, recipe

#set text(lang: "de", region: "DE")

#recipe_yaml("recipe.yaml")

#recipe(
  title: "Suppe",
  prep-time: [2h],
  servings: [3 Personen],
  ingredients: [
    / 100g: Käse
    / 100g: Butter
    / 100g: Milch
    / 100g: Mehl
  ],
  instructions: (
    [
      First step
      #lorem(20)
    ],
    [
      Second step
      #lorem(20)
    ],
    [
      #lorem(30)
    ]
  ),
  images: (
    small: "images/small.jpg", 
    big: "images/big.jpg"
    ),
  hint: [#lorem(30)]
)
