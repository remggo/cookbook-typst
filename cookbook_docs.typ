#import "@preview/tidy:0.2.0"
#let docs = tidy.parse-module(read("cookbook.typ"))
#tidy.show-module(docs, style: tidy.styles.default)