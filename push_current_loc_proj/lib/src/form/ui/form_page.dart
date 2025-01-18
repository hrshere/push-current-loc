import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/colors_constant.dart';
import '../../../utils/utils.dart';
import '../controller/contacts_controller.dart';

class ContactsScreen extends StatelessWidget {
  final ContactsController controller = Get.put(ContactsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Name Field
              Obx(() => TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  errorText: controller.nameError.value.isNotEmpty
                      ? controller.nameError.value
                      : null,
                ),
                onChanged: (value) => controller.name.value = value,
              )),
              const SizedBox(height: 16),

              // Phone Field
              Obx(() => TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone',
                  errorText: controller.phoneError.value.isNotEmpty
                      ? controller.phoneError.value
                      : null,
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) => controller.phone.value = value,
              )),
              const SizedBox(height: 16),

              // Address Field
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.checkAndRequestLocationPermission();
                      // logg.i('Location button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BorderColor.orange,
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Location'),
                  ),
                  Obx(() {
                    // Show a loading indicator if loading is true
                    if (controller.loading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Show location info if location is selected
                    if (controller.selectedLocation.value != null) {
                      return Column(
                        children: [
                          Text('Location: ${controller.selectedLocation.value}'),
                          TextButton(
                            onPressed: controller.resetLocation,
                            child: const Text('Reset Location'),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // Latitude Field
              Obx(() => TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Latitude',
                  errorText: controller.latitudeError.value.isNotEmpty
                      ? controller.latitudeError.value
                      : null,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller:  TextEditingController(text: controller.latitude.value),
              )),
              const SizedBox(height: 16),

              // Longitude Field
              Obx(() => TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Longitude',
                  errorText: controller.longitudeError.value.isNotEmpty
                      ? controller.longitudeError.value
                      : null,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller:  TextEditingController(text: controller.longitude.value),
              )),
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  logg.i('Submit button pressed');
                  await controller.addContact();
                },
                child: const Text('Add Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
