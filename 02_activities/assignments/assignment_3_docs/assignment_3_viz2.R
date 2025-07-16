# DSI Visualization 2 - Assignment 3
# Ontario District School Board Revenues and Expenses (2019–2024)
# Using Ministry of Education Data

library(readxl)
library(dplyr)
library(ggplot2)
library(scales)
library(tidyverse)

# Download and extract
zip_url <- "https://data.ontario.ca/dataset/acc1ff32-3995-469d-9e94-adedf17f9c4e/resource/2a1c0f32-22b9-4bde-bc79-499b460282d5/download/en_2023-2024.zip"
zip_path <- tempfile(fileext = ".zip")
download.file(zip_url, zip_path, mode = "wb")
unzip_dir <- tempfile()
unzip(zip_path, exdir = unzip_dir)

# Read Excel
xlsx_path <- file.path(unzip_dir, "EN_2023-2024", "14_Financial_Summary_2023-2024_EN.xlsx")
raw_data <- read_excel(xlsx_path)

# Prepare data
finance <- raw_data %>%
  select(
    Year = `Academic Year`,
    Revenue = `District School Boards - Revenues`,
    Surplus = `District School Boards - Surplus/(deficit) at year end`
  ) %>%
  filter(!is.na(Revenue))

finance_long <- finance %>%
  pivot_longer(cols = c(Revenue, Surplus), names_to = "Type", values_to = "Amount")

# Plot
ggplot(finance_long, aes(x = Year, y = Amount, fill = Type)) +
  geom_col(position = position_dodge(width = 0.7), width = 0.6) +
  scale_fill_manual(values = c("Revenue" = "#4C72B0", "Surplus" = "#F17CB0")) +  # Blue and pink
  scale_y_continuous(
    labels = label_number(scale = 1e-9, suffix = "B", accuracy = 1),
    expand = expansion(mult = c(0, 0.1))
  ) +
  labs(
    title = "Ontario School Board Revenues and Surplus/(Deficit) at Year End",
    x = NULL,
    y = "Dollars (Billions)",
    fill = NULL
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "top"
  )
