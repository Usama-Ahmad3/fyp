import 'package:flutter/material.dart';
import 'package:wizmo/models/sell_car_model.dart';
import 'package:wizmo/res/colors/app_colors.dart';
import 'package:wizmo/res/common_widgets/button_widget.dart';
import 'package:wizmo/res/common_widgets/text_field_widget.dart';
import 'package:wizmo/utils/navigator_class.dart';
import 'package:wizmo/view/home_screens/sell_screen/add_photo/add_photo.dart';
import 'package:wizmo/view/home_screens/sell_screen/app_bar_widget.dart';
import 'package:wizmo/view/home_screens/sell_screen/description_screen/decription_template.dart';

class DescriptionScreen extends StatefulWidget {
  final SellCarModel sellCarModel;
  const DescriptionScreen({super.key, required this.sellCarModel});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  TextEditingController descriptionController = TextEditingController();
  void autoDescription() {
    if (widget.sellCarModel.auto! == true) {
      widget.sellCarModel.description =
          descriptionTemplate(widget.sellCarModel);
    }
    descriptionController.text = widget.sellCarModel.description.toString();
  }

  @override
  void initState() {
    autoDescription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.08),
        child: AppBarWidget(
          title: 'Edit Description',
          color1: AppColors.buttonColor,
          color2: AppColors.buttonColor,
          color3: AppColors.grey,
          size: MediaQuery.sizeOf(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.048,
            ),
            TextFieldMultiWidget(
                controller: descriptionController,
                hintText: '',
                maxLine: 23,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.034),
                    borderSide: BorderSide(color: AppColors.white))),
            SizedBox(
              height: height * 0.05,
            ),
            Center(
              child: ButtonWidget(
                  text: 'Continue',
                  onTap: () {
                    widget.sellCarModel.description =
                        descriptionController.text;
                    Navigation().push(
                        AddPhoto(sellCarModel: widget.sellCarModel), context);
                  }),
            ),
            SizedBox(
              height: height * 0.012,
            ),
            Center(
              child: ButtonWidget(
                  text: 'Back',
                  onTap: () {
                    Navigation().pop(context);
                  }),
            ),
            SizedBox(
              height: height * 0.013,
            )
          ],
        ),
      ),
    );
  }
}
