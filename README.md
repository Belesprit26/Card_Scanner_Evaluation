Card Scanner Evaluation

A small project demonstrating card validation techniques. Built using the BLoC pattern to ensure reusability and efficiency given its complexity. This project includes functionalities for scanning and validating credit card details, and managing card information locally on the device.


Features:


Card Details Submission: Allows users to enter and submit credit card details, including card number, CVV, expiry date, and issuing country.

Card Type Inference: Automatically infers the card type based on the card number.

Validation: Ensures the card details entered are valid, including checks for card number, CVV, and expiry date.

Banned Countries List: Configurable list of banned countries. Cards from these countries cannot be saved.

Local Storage: Stores valid card details locally on the device using SharedPreferences.

Card Scanning: Allows users to scan their card using their phone's camera. The scanner reads the card number and expiry date and auto-fills the fields.

Duplicate Check: Prevents saving duplicate card numbers.

Card List Display: Displays a list of all saved cards, which can be accessed through an action button in the app bar.

Getting Started

Prerequisites:

Flutter SDK
Dart SDK
A device or emulator running Android or iOS

Installation
Clone the repository:

1. git clone https://github.com/Belesprit26/Card_Scanner_Evaluation.git
cd Card_Scanner_Evaluation

2. flutter pub get
   
3. flutter run

Configuration:

Banned Countries List -
The list of banned countries is stored in banned_countries.dart. 
To configure the banned countries, update the list in this file:

Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any enhancements or bug fixes.

License

This project is licensed under the MIT License - see the LICENSE file for details.

Contact

For any questions or feedback, please reach out to Belesprit Mkhatshwa.



