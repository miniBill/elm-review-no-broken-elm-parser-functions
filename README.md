# elm-review-no-broken-elm-parser-functions

Provides [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) rules to check for usage of `Parser.lineComment`, `Parser.multiComment`, `Parser.chompUntil` and `Parser.chompUntilEndOr`.

As detailed in [the bug report](https://github.com/elm/parser/issues/53), those functions cause the position to become desynchronized, and should not be used. Use the functions from [`pithub/elm-parser-bug-workaround`](https://package.elm-lang.org/packages/pithub/elm-parser-bug-workaround/latest/Parser-Workaround) instead.

This rule intentionally doesn't provide a fix, because depending on your use case you may want the `Before` or `After` versions. Check the [linked documentation](https://package.elm-lang.org/packages/pithub/elm-parser-bug-workaround/latest/Parser-Workaround#workaround) for picking the correct version.

## Provided rules

-   [`NoBrokenParserFunctions`](https://package.elm-lang.org/packages/miniBill/elm-review-no-broken-elm-parser-functions/1.0.0/NoBrokenParserFunctions) - Reports usages of the broken functions.

## Configuration

```elm
module ReviewConfig exposing (config)

import NoBrokenParserFunctions
import Review.Rule exposing (Rule)

config : List Rule
config =
    [ NoBrokenParserFunctions.rule
    ]
```

## Try it out

You can try the example configuration above out by running the following command:

```bash
elm-review --template miniBill/elm-review-no-broken-elm-parser-functions/example
```

## Thanks

Thanks to [Ambue](https://ambue.com) for letting me implement this during work hours!
