/* Helper Functions */
#let fill_image(path) = {
  if (path != none) {
    image(path, height: 100%, width: 100%)
  }
}

#let emoji_text(emoji, text) = [
  #box(width: 1em)[#emoji] #text #h(0.5em)
]


/// This function prints a recipe
/// 
/// - title (content): The recipe Title
/// - prep-time (content): The time it takes
/// - servings (string): The servings 
/// - ingredients (content): The ingredients in the
///   that are going into the recipe
/// - images (array): Array of strings for the paths
/// - title-font (string): Font name to use for the title of the recipe
/// - text-font (string): Font name to use for the main text of the recipe, the step
/// - ingredients-font (string): Font name to use for the ingredients section of the recipe
/// - numbering-font (string): Font name to use for the step numbers
/// -> content
#let recipe(
  title: [],
  prep-time: [],
  servings: [],
  baking-time: none,
  fanoven-heat: none,
  topbottom-heat: none,
  diameter: none,
  dimensions: none,
  ingredients: [],
  instructions: (),
  images: none,
  hint: none,
  accent-color: rgb("#7F0000"),
  hint-title: "Tipp",
  title-font: "linux libertine",
  text-font: "linux libertine",
  ingredients-font: "linux libertine",
  numbering-font: "linux libertine",
  hint-font: "linux libertine"
) = [
  #set par(justify: true)
  #counter("steps").update(1)
  #if images != none {
    box(height: 20%)[
      #grid(
        columns: (1fr, 2fr),
        column-gutter: 1em,
        { fill_image(images.small) },
        { fill_image(images.big) },
      )
    ]
  }
  #v(1em)
  #block()[
    #set text(size: 36pt, fill: accent-color, style: "italic", font: title-font)
    #title
  ]
  #v(5mm)
  #block[
    #emoji_text(emoji.hourglass, prep-time)
    #emoji_text(emoji.plate.cutlery, servings)

    #if(baking-time != none){
        [#emoji_text(emoji.gloves, baking-time)]
        [#emoji_text(emoji.thermometer, none)]
        if (fanoven-heat != none){
          [#emoji_text(emoji.fire, fanoven-heat)]
        }
        if (topbottom-heat != none){
          [#emoji_text(emoji.fire, topbottom-heat)]
        }
        if (diameter != none){
          [#emoji_text(emoji.square.white, diameter)]
        }
        if (dimensions != none){
          [#emoji_text(emoji.square.white, dimensions)]
        }    
    }
  ]

  #v(1em)

  #grid(
    columns: (1fr, 2fr),
    column-gutter: 1cm,
    {
      set text(font: ingredients-font)
      set list(marker: none, indent: 0pt, body-indent: 0pt)
      ingredients
    },
    [
      #let mine = counter("steps")
      #let ins = ([a], [b])
      #let thing = instructions.fold(
        (),
        (acc, it) => {
          acc.push([
            #set text(size: 30pt, fill: accent-color, style: "italic", font: numbering-font)
            #mine.display("1")
            #mine.step()
          ])
          acc.push(it)
          acc
        },
      )
      #set text(font: text-font)
      #grid(columns: (10%, 90%), row-gutter: 1.6em, ..thing)
    ],
  )

  #if (hint != none){
    set text(font: hint-font)
    align(bottom, [
      #line(length: 30%, stroke: 1.5pt+accent-color, start: (-5%, 0%))
      #line(start: (-3%, -3%), stroke: 1.5pt+accent-color, end: (-3%, 7%))
      #v(-9%)
      #text(size: 16pt, fill: accent-color)[*#hint-title*]

      #hint    
    ])
  }
  #pagebreak()
]


#let recipe_yaml(
  recipe_yaml,
  accent-color: rgb("#7F0000"),
  hint-title: "Tipp",
  title-font: "linux libertine",
  text-font: "linux libertine",
  ingredients-font: "linux libertine",
  numbering-font: "linux libertine",
  hint-font: "linux libertine"
) = {

  let rdata = yaml(recipe_yaml)

  assert(rdata.recipe-version == 1, message: "Your YAML is not compatible")

  let fanoven = none
  let topbottom = none
  let diameter = none
  let dimensions = none
  let baking-time = none
  let images = none
  let ingredients = none
  let hint = none

  if ("baking" in rdata.metadata) {
    baking-time = rdata.metadata.baking.time
    if ("fanoven" in rdata.metadata.baking){
      fanoven = rdata.metadata.baking.fanoven
    }
    if ("topbottom" in rdata.metadata.baking){
      topbottom = rdata.metadata.baking.topbottom
    }
    if ("diameter" in rdata.metadata.baking){
      diameter = rdata.metadata.baking.diameter
    }
    if ("dimensions" in rdata.metadata.baking){
      dimensions = rdata.metadata.baking.dimensions
    }
  }

  if ("images" in rdata.metadata){
    images = (big: rdata.metadata.images.big, small: rdata.metadata.images.small)
  }

  ingredients = [
    #for ingredient in rdata.ingredients {
      if type(ingredient) == dictionary [
        #for (ing, amount) in ingredient {
          if amount == "title" [
            / #ing:
          ] else [
            / #amount: #ing
          ]
        }
      ] 
    }      
  ]

  if ("hint" in rdata){
    hint = rdata.hint
  }

  recipe(
    title: [#rdata.name],
    prep-time: [#rdata.metadata.preptime],
    baking-time: baking-time,
    fanoven-heat: fanoven,
    topbottom-heat: topbottom,
    dimensions: dimensions,
    diameter: diameter,
    servings: [#rdata.metadata.servings.number #rdata.metadata.servings.name],
    images: images,
    ingredients: ingredients,
    hint: hint,
    instructions: (
        rdata.steps
    )
  )
}