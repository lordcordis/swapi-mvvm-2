# SWAPI

SWAPI is an iOS application that leverages the Model-View-ViewModel (MVVM) architecture pattern to present data from the Star Wars API (SWAPI) in a user-friendly interface. This project showcases the implementation of clean architecture principles in iOS development using Swift.

## Features

- **MVVM Architecture**: Implements the MVVM pattern for a clear separation of concerns and enhanced testability.
- **API Integration**: Fetches data from the SWAPI using URLSession with paginated loading.
- **Diffable Data Sources**: Uses `UITableViewDiffableDataSource` and `UICollectionViewDiffableDataSource` for smooth, animated UI updates.
- **Search**: Filter entities with an integrated search bar.
- **Sorting**: Sort entity lists alphabetically (loads all pages before sorting).
- **Detail Views**: Drill into any entity to see its full description and related entities (films, characters, planets, species, starships, vehicles) with SF Symbol icons.
- **Preloaded Detail Data**: All related entity data is fetched before the detail view is presented.
- **Localization**: Fully localized in English and Russian via String Catalog (`.xcstrings`).
- **Error Handling**: Displays a user-friendly error view with pull-to-refresh when the API is unreachable.

## Screenshots

![IMG_5264](https://github.com/user-attachments/assets/7ff1fc75-9b5e-4c56-bd4f-4bb73b45edfc)
![IMG_5265](https://github.com/user-attachments/assets/fe9e11f0-11c3-4863-9ddf-e8e829c7c287)
![IMG_5266](https://github.com/user-attachments/assets/62257486-f5c6-4bae-8517-4f8597426637)

## Getting Started

### Prerequisites

- Xcode 15.0 or higher
- iOS 16.2 or higher

### License
This project is licensed under the MIT License. See the LICENSE file for details.

