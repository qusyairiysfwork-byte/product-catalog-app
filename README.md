# Product Catalog App

A simple Flutter product catalog application built as part of a Junior Mobile Developer technical assessment.

The application uses the DummyJSON API to display products, support pagination, product search, and product details.

## Features

### Required Features

* Product listing with:

  * Product thumbnail
  * Product title
  * Product price
* Pagination using `skip` and `limit`
* Product detail screen with:

  * Description
  * Price
  * Rating
  * Product images
* Loading, error, empty, and success states
* Retry button when loading fails
* Debounced product search
* Separate data and presentation layers

### Additional Features

* Two-column product grid UI
* Product rating displayed in the product card
* Swipeable product images on the detail screen
* Unit test for product JSON parsing

## Tech Stack

* Flutter
* Dart
* HTTP package
* DummyJSON API

## Architecture

The project uses a simple two-layer structure suitable for the size of the application.

```text
lib/
├── data/
│   ├── models/
│   │   ├── product.dart
│   │   └── product_response.dart
│   └── services/
│       └── product_service.dart
│
├── presentation/
│   ├── screens/
│   │   ├── product_list_screen.dart
│   │   └── product_detail_screen.dart
│   └── widgets/
│       └── product_card.dart
│
└── main.dart
```

### Data Layer

The data layer contains the product models and `ProductService`.

`ProductService` is responsible for communicating with the DummyJSON API for:

* Product listing
* Product pagination
* Product search
* Product details

### Presentation Layer

The presentation layer contains the screens and reusable UI widgets.

`ProductListScreen` handles:

* Product list state
* Pagination
* Search
* Loading and error states
* Navigation to product details

`ProductDetailScreen` displays the selected product information.

`ProductCard` handles the visual presentation of each product in the grid.

## Search Approach

The application uses the DummyJSON server-side search endpoint:

```text
/products/search?q=...
```

A 500ms debounce is used so that the application does not send an API request for every keystroke.

Server-side search was chosen because the API already provides a search endpoint and it keeps the search logic simple.

## Pagination

The product list uses the API's `limit` and `skip` parameters.

The initial request loads 20 products:

```text
limit=20
skip=0
```

When the user scrolls near the bottom, the next page is requested using the updated `skip` value.

## Running the Project

Make sure Flutter is installed and configured.

Then run:

```bash
flutter pub get
flutter run
```

To run the tests:

```bash
flutter test
```

To check the project for analysis issues:

```bash
flutter analyze
```

## Testing

A unit test is included to verify that product response JSON is correctly converted into the application's product models.

The test does not require a real network connection.

## Unfinished / Not Implemented

The following optional features were not implemented:

* Pull-to-refresh
* Advanced image loading placeholders and error handling
* More extensive automated tests

These were intentionally left out to keep the implementation within the assessment timebox and maintain a simple project structure.

## AI Assistance

AI tools were used for limited guidance and research during development, including clarification of Flutter concepts, API integration, and debugging.

The application structure, implementation decisions, and core logic were reviewed and understood during development. The project was kept intentionally simple because this is my first Flutter project.

## Notes

This project was developed as a learning exercise while becoming familiar with Flutter and Dart. The focus was on completing the required functionality with a simple and understandable architecture rather than introducing unnecessary complexity.
