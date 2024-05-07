class DynamicCarDetailModel {
  String? description;
  String? model;
  String? name;
  String? addCarId;
  String? price;
  String? sellerImage;
  String? sellerType;
  String? sellerName;
  String? location;
  String? latitude;
  String? longitude;
  String? number;
  bool? saved;
  String? email;
  List? images;

  DynamicCarDetailModel(
      {this.description,
      this.model,
      this.name,
      this.price,
      this.addCarId,
      this.sellerType,
      this.saved,
      this.sellerName,
      this.location,
      this.latitude,
      this.longitude,
      this.number,
      this.email,
      this.sellerImage,
      this.images});
}
