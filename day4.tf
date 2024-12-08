locals {
  d4_input_right = local.days[4] ? module.d4_parse_input.first : ["AAA", "AAA", "AAA"]
  d4_input_split = tolist([
    for line in local.d4_input_right : split("", line)
  ])
  d4_col_length = length(local.d4_input_split)
  d4_row_length = length(local.d4_input_split[0])
  d4_input_left = [
    for line in local.d4_input_right : join("", reverse(split("", line)))
  ]

  d4_input_down = [
    for i in range(length(local.d4_input_right[0])) : join("", [
      for j in range(length(local.d4_input_right)) : local.d4_input_split[j][i]
    ])
  ]

  d4_input_up = [
    for line in local.d4_input_down : join("", reverse(split("", line)))
  ]

  d4_input_se = concat(
    [
      for row in range(local.d4_row_length) : join("", [
        for col in range(local.d4_col_length - row) : join("", [
          local.d4_input_split[row + col][col]
        ])
      ])
    ],
    [
      for col in range(1, local.d4_col_length) : join("", [
        for row in range(local.d4_row_length - col) : join("", [
          local.d4_input_split[row][col + row]
        ])
      ])
  ])

  d4_input_nw = [
    for line in local.d4_input_se : join("", reverse(split("", line)))
  ]


  d4_input_ne = concat(
    [
      for row in range(local.d4_row_length) : join("", [
        for col in range(row + 1) : join("", [
          local.d4_input_split[row - col][col]
        ])
      ])
    ],
    [
      for col in range(1, local.d4_col_length) : join("", [
        for row in range(local.d4_row_length, col) : join("", [
          local.d4_input_split[row - 1][local.d4_row_length - row + col]
        ])
      ])
    ]
  )

  d4_input_sw = [
    for line in local.d4_input_ne : join("", reverse(split("", line)))
  ]

  d4_all_lines = concat(
    local.d4_input_right,
    local.d4_input_left,
    local.d4_input_down,
    local.d4_input_up,
    local.d4_input_se,
    local.d4_input_nw,
    local.d4_input_ne,
    local.d4_input_sw,
  )

  d4_count = [
    for line in local.d4_all_lines : length(regexall("XMAS", line))
  ]

  d4_b_all_se = concat(
    [
      for row in range(local.d4_row_length) : [
        for col in range(local.d4_col_length - row) : {
          "letter" = local.d4_input_split[row + col][col],
          "row"    = row + col,
          "col"    = col
        }
      ]
    ],
    [
      for col in range(1, local.d4_col_length) : [
        for row in range(local.d4_row_length - col) : {
          "letter" = local.d4_input_split[row][col + row],
          "row"    = row,
          "col"    = col + row
        }
      ]
  ])

  d4_b_se = [
    for line in local.d4_b_all_se : line if length(line) >= 3
  ]

  d4_b_se_coord = toset(concat([
    for line in local.d4_b_se : [
      for i in range(length(line) - 2) : "${line[i + 1].row}-${line[i + 1].col}" if contains(["MAS", "SAM"], "${line[i].letter}${line[i + 1].letter}${line[i + 2].letter}")
    ]
  ]...))

  d4_b_all_ne = concat(
    [
      for row in range(local.d4_row_length) : [
        for col in range(row + 1) : {
          "letter" = local.d4_input_split[row - col][col],
          "row"    = row - col,
          "col"    = col
        }
      ]
    ],
    [
      for col in range(1, local.d4_col_length) : [
        for row in range(local.d4_row_length, col) : {
          "letter" = local.d4_input_split[row - 1][local.d4_row_length - row + col],
          "row"    = row - 1,
          "col"    = local.d4_row_length - row + col
        }
      ]
    ]
  )


  d4_b_ne = [
    for line in local.d4_b_all_ne : line if length(line) >= 3
  ]

  d4_b_ne_coord = toset(concat([
    for line in local.d4_b_ne : [
      for i in range(length(line) - 2) : "${line[i + 1].row}-${line[i + 1].col}" if contains(["MAS", "SAM"], "${line[i].letter}${line[i + 1].letter}${line[i + 2].letter}")
    ]
  ]...))

  d4_b_x_mas = setintersection(local.d4_b_se_coord, local.d4_b_ne_coord)
}

module "d4_parse_input" {
  source   = "./parse-input"
  filename = "./inputs/day4.input"
  sep      = ["\n"]
}

output "day4-a" {
  value = local.days[4] ? sum(local.d4_count) : null
}

output "day4-b" {
  value = local.days[4] ? length(local.d4_b_x_mas) : null
}
