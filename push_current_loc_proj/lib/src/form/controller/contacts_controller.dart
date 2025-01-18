import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:push_current_loc_proj/utils/preference_manager.dart';
import 'package:validators/validators.dart';

import '../../../utils/utils.dart';

class ContactsController extends GetxController {
  var loading = false.obs;  // Loading state
  var selectedLocation = Rxn<String>(); // Location as a string, you can change it if needed
  // Method to check and request location permission
  Future<void> checkAndRequestLocationPermission() async {
    loading.value = true;  // Start loading
    // Check if location permission is granted
    var status = await Permission.location.status;
    if (!status.isGranted) {
      // Request permission
      await Permission.location.request();
    }

    // Once granted, get the location
    if (await Permission.location.isGranted) {
      _getCurrentLocation();
    } else {
      // Handle location permission denial
      print("Location permission denied.");
    }
  }

  // Method to get the current location and reverse geocode it to get the place name
  Future<void> _getCurrentLocation() async {
    try {
      // Get the current position (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
latitude.value = position.latitude.toString();
longitude.value = position.longitude.toString();
      // Reverse geocode the coordinates to get the place name (address)
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        // Get the first placemark and use it as the place name
        Placemark place = placemarks.first;
        String placeName = "${place.name}, ${place.locality}, ${place.country}";

        // Save the place name
        selectedLocation.value = placeName;
      }
    } catch (e) {
      print("Error getting location: $e");
      selectedLocation.value = "Unable to retrieve location.";
    }
    finally {
      loading.value = false;  // Stop loading
    }
  }

  // Reset location
  void resetLocation() {
    selectedLocation.value = null;
    latitude.value = '';
    longitude.value = '';
  }
  // Observable variables for user inputs
  var name = ''.obs;
  var phone = ''.obs;
  var latitude = ''.obs;
  var longitude = ''.obs;

  // For validation purposes
  var nameError = ''.obs;
  var phoneError = ''.obs;
  var addressError = ''.obs;
  var latitudeError = ''.obs;
  var longitudeError = ''.obs;

  // Firebase Firestore reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Validation function
  bool validateFields() {
    bool isValid = true;

    // Clear previous errors
    nameError.value = '';
    phoneError.value = '';
    addressError.value = '';
    latitudeError.value = '';
    longitudeError.value = '';

    // Name Validation
    if (name.value.isEmpty) {
      nameError.value = "Name is required";
      isValid = false;
    }

    // Phone Validation
    if (phone.value.isEmpty || !isNumeric(phone.value)) {
      phoneError.value = "Enter a valid phone number";
      isValid = false;
    }

    // Address Validation
    if (selectedLocation.value == null) {
      addressError.value = "Address is required";
      isValid = false;
    }

    // Latitude and Longitude Validation
    if (latitude.value.isEmpty || !isFloat(latitude.value)) {
      latitudeError.value = "Enter a valid latitude";
      isValid = false;
    }
    if (longitude.value.isEmpty || !isFloat(longitude.value)) {
      longitudeError.value = "Enter a valid longitude";
      isValid = false;
    }

    return isValid;
  }

  // Function to add contact to Firestore
  Future<void> addContact() async {
    logg.i('Validating fields...');
    logg.i({
      'name': name.value,
      'phone': phone.value,
      'address': selectedLocation.value,
      'latitude': double.parse(latitude.value),
      'longitude': double.parse(longitude.value),
      'deviceToken': PreferenceManager.getData(PreferenceManager.firebaseToken)
    });
    if (validateFields()) {
      logg.i('Adding contact...');
      try {
        // Save contact to Firestore
        await _firestore.collection('contacts').add({
          'name': name.value,
          'phone': phone.value,
          'address': selectedLocation.value,
          'latitude': double.parse(latitude.value),
          'longitude': double.parse(longitude.value),
          'deviceToken': PreferenceManager.getData(PreferenceManager.firebaseToken)
        });
        Get.snackbar("Success", "Contact added successfully",
            snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar("Error", "Failed to add contact: $e",
            snackPosition: SnackPosition.BOTTOM);
      }
    }
    else{
      Get.snackbar("Error", "Please fill all the fields",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
