class EventModel{

  static const String jEventName = 'event_name', jEventDetails = 'event_details',
      jEventImage = 'event_image', jEventDate = 'event_date', jBanquetId = 'banquet_id', jBanquetName = 'banquet_name';

  String eventName, eventDetails, eventImage, eventDate, banquetId, banquetName;

  EventModel({required this.eventName, required this.eventDetails,
    required this.eventImage, required this.eventDate, required this.banquetId, required this.banquetName});

  factory EventModel.fromJson(Map<String, dynamic> json){
    return EventModel(eventName: json[jEventName], eventDetails: json[jEventDetails],
        eventImage: json[jEventImage], eventDate: json[jEventDate],
        banquetId: json[jBanquetId], banquetName: json[jBanquetName]);
  }

  Map<String, dynamic> toJson(){
    return {
      jEventName: eventName,
      jEventDetails: eventDetails,
      jEventImage: eventImage,
      jEventDate: eventDate,
      jBanquetId: banquetId,
      jBanquetName: banquetName
    };
  }
}