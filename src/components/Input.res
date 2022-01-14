module Styles = {
  open Emotion

  let {toString: colorToString} = module(Theme.Colors)

  let input = css({
    "color": Theme.Colors.white->colorToString,
    "fontSize": "1.8rem",
    "border": "none",
    "padding": "1.6rem 1.6rem",
    "borderRadius": "6px",
    "outline": "none",
    "width": "100%",
    "background": Theme.Colors.grayDark->colorToString,
    "&:placeholder": {
      "color": Theme.Colors.grayLight->colorToString,
    },
    "&:hover": {
      "boxShadow": `1px 0px 1px ${Theme.Colors.primary->colorToString}`,
    },
    "&:focus": {
      "transition": "300ms",
      "boxShadow": `0px 0px 0px 2px ${Theme.Colors.primary->colorToString}`,
    }
  })
}

@react.component
let make = (~onChange=?, ~name=?, ~value=?, ~placeholder=?) => {
  <input ?value ?onChange ?name ?placeholder className=Styles.input />
}