# TableView.jl

[![CI](https://github.com/gryumova/TableView.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/gryumova/TableView.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/gryumova/TableView.jl/graph/badge.svg?token=vsEt7JjjYT)](https://codecov.io/gh/gryumova/TableView.jl)

TableView is a Julia package that provides functionality for visualization table data throw generating an HTML file based on AgGrid. You can flexibly customize the style and filtering of your data.

## Installation
To install TableView, simply use the Julia package manager:
```
] add TableView
```

## Usage

A simple example of a table with cryptocurrency data:

```julia
using TableView

# Let's first declare the column 'headers' and 'cryptocurrency' row values
headers = (:Name, :Price, Symbol("1h"), Symbol("24h"), Symbol("7d"), Symbol("Market cap"), Symbol("Volume(24h)"))
cryptocurrency = (
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/1.png  width=auto height=12> BTC",
        51_704.17, 0.0011, -0.0088, 0.0748, 1_015_017_701_069, 19_853_081_339,
    )),
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png  width=auto height=12> ETH",
        2_797.54, -0.0009, 0.0181, 0.1140, 336_167_174_675, 18_875_589_553,
    )),
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/825.png  width=auto height=12> USDT",
        1.00, 0.0001, 0.0001, -0.0001, 97_687_504_632, 46_870_650_622,
    )),
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/1839.png  width=auto height=12> BNB",
        353.33, 0.0002, 0.0018, 0.0994, 52_838_510_510, 1_006_060_987,
    )),
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/5426.png  width=auto height=12> SOL",
        111.63, 0.0022, 0.0436, 0.0209, 49_199_185_486, 1_376_798_775,
    )),
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/52.png  width=auto height=12> XRP",
        0.5567, -0.0017, 0.0156, 0.0513, 30_372_867_543, 802_166_044,
    )),
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/3408.png  width=auto height=12> USDC",
        1.00, 0.0001, -0.0003, -0.0002, 28_093_824_870, 3_967_216_040,
    )),
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/2010.png  width=auto height=12> ADA",
        0.6255, -0.0064, 0.0794, 0.1420, 22_180_294_747, 735_219_506,
    )),
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/5805.png  width=auto height=12> AVAX",
        40.23, 0.0039, 0.0304, -0.0057, 14_786_919_682, 441_694_819,
    )),
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/74.png  width=auto height=12> DOGE",
        0.08361, 0.0002, 0.0030, 0.0207, 11_966_508_925, 299_147_452,
    )),
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/1958.png  width=auto height=12> TRX",
        0.1352, -0.0003, 0.0066, 0.0871, 11_903_355_674, 246_026_974,
    )),
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/1975.png  width=auto height=12> LINK",
        19.90, 0.0014, -0.0086, -0.0141, 11_684_892_535, 341_667_040,
    )),
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/6636.png  width=auto height=12> DOT",
        7.78, 0.0006, 0.0386, 0.0802, 9_959_472_484, 198_049_180,
    )),
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/3890.png  width=auto height=12> MATIC",
        0.9682, -0.0138, 0.0427, 0.1463, 9_312_126_213, 344_848_552,
    )),
    NamedTuple{headers}((
        "<img src=https://s2.coinmarketcap.com/static/img/coins/64x64/11419.png  width=auto height=12> TON",
        2.27, 0.0065, -0.0286, 0.0822, 7_875_889_558, 33_988_801,
    )),
)

# Next we need to specify column settings, such as filtering or formatting and styling
settings = Dict(
    "Name" => Dict(
        "filter" => "text",
    ),
    "Price" => Dict(
        "filter" => "number",
        "formatter" => Dict("style" => "currency", "currency" => "USD"),
    ),
    "1h" => Dict(
        "formatter" => Dict("style" => "percent"),
        "style" => Dict(
            "threshold" => 0.0,
            "colorUp" => "#26b521",
            "colorDown" => "#ba4022",
            "text-align" => "center",
        ),
    ),
    "24h" => Dict(
        "formatter" => Dict("style" => "percent"),
        "style" => Dict(
            "threshold" => 0.0,
            "colorUp" => "#26b521",
            "colorDown" => "#ba4022",
            "text-align" => "center",
        ),
    ),
    "7d" => Dict(
        "formatter" => Dict("style" => "percent"),
        "style" => Dict(
            "threshold" => 0.0,
            "colorUp" => "#26b521",
            "colorDown" => "#ba4022",
            "text-align" => "center",
        ),
    ),
    "Market cap" => Dict(
        "filter" => "number",
        "formatter" => Dict("style" => "currency", "currency" => "USD"),
    ),
    "Volume(24h)" => Dict(
        "filter" => "number",
        "formatter" => Dict("style" => "currency", "currency" => "USD"),
    ),
    "cols_filter" => true,
)

# Finally, let's pass all the values to the function that creates the HTML table
show_table(cryptocurrency, column_settings = settings, resize = false, out_file = "./cryptocurrency_showcase.html")
```

![cryptocurrency_showcase](/docs/src/assets/cryptocurrency_showcase.png)

You can find an interactive version of this example in the [documentation](...).

## Contributing
Contributions to TableView are welcome! If you encounter a bug, have a feature request, or would like to contribute code, please open an issue or a pull request on GitHub.
