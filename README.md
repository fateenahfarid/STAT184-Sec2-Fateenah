## Introduction
This project is an R-based data processing and analyzation related to U.S. Armed Forces Personnel. This project uses the U.S. Armed Forces Active-Duty Personnel by Service Branch, Sex, and Pay Grade data that is included in this repository under the data folder. The aim of this project is to transform the given U.S. Armed Forces data and combine web-scraping data to form a table where each row represents a group of army and another table where each row represents an individual army personnel.

## Implementation
### 1. Load Required Packages

The project requires the following R packages:
- **`tidyverse`**: For data wrangling.
- **`rvest`**: For web scraping and HTML parsing.

### 2. Get Armed Forces Data

#### a. Download and Load Data
The data is provided in the repository under the data folder as `US_Armed_Forces.csv`. The dataset can be read using `read.csv()`.

#### b. Clean Data
The imported data uses the following functions from `tidyverse`:
- **`select`**: Removes unnecessary columns to focus on relevant data.
- **`rename`**: Renames columns for better readability.
- **`slice`**: Excludes specific rows to remove summary or invalid data.
- **`pivot_longer`**: Reshapes the dataset, converting wide-format columns into a long-format structure.
- **`mutate`**: Adds or modifies columns, including data type conversions.
- **`filter`**: Filters out rows with invalid or missing data.

### 3. Get Army Ranks Data

#### a. Web Scraping
Army ranks data is extracted from a website using `rvest` functions:
- **`read_html`**: Reads the HTML content of the webpage.
- **`html_elements`**: Selects the desired HTML elements containing tabular data.
- **`html_table`**: Converts the extracted HTML elements into a list of tables.

#### b. Convert List to Table
The extracted tables are merged into a single table using `bind_cols()`.

#### c. Clean Data
- **`rename`**: Standardizes column names.
- **`slice`**: Removes unnecessary rows.
- **`pivot_longer`**: Reshapes the data into a long format.
- **`filter`**: Filters out unwanted rows.

### 4. Construct Aggregated Tables

#### a. A case represents a group of army
A table is constructed where each row represents a group (defined by pay grade and service branch). This is achieved using:
- **`left_join`**: Combines the `armedForces` and `armyRanks` datasets on matching columns (`Pay Grade` and `Service Branch`).

#### b. A case represents an individual army
Another table is created where each row represents an individual service member. This is achieved using:
- **`uncount`**: Expands the dataset by repeating rows based on the "Count" column, ensuring each row represents one person.

## Results

#### 1. The armyGroup Table
The armyGroup table should contain 220 entries and 6 columns: `Pay Grade`, `Service Branch`, `Gender`, `Count`, `Category`, `Ranks`.

#### 2. The armyIndividual Table
The armyIndividual table should contain 23,844 entries and 5 columns:  `Pay Grade`, `Service Branch`, `Gender`, `Category`, `Ranks`.

## Contacts

For questions or other opportunities:
**Email**: fateenahfarid@psu.edu

