
class OrderService{
  double price;
  String service;
  String providerEmail;
  String ownerEmail;
  int numofpets;
  String address;
  String dateTime;
  static const PROVIDEREMAIL = 'provideremail';
  static const PRICE = 'price';
  static const SERVICE = 'service';
  static const OWNEREMAIL = 'owneremail';
  static const NUMBEROFPETS = 'numofpets';
  static const ADDRESS = 'address';
  static const ORDEREDSERVICE ='orderedservice';
  static const DATETIME = 'datetime';
  OrderService({
    this.price=0,
    this.service='',
    this.providerEmail='',
    this.ownerEmail='',
    this.numofpets=0,
    this.address='',
    this.dateTime,
  });
  
  OrderService.setOrder(
    double price, String service, String provideremail, 
    String ownerEmail, int numofpets, String address, String dateTime){
    this.price = price;
    this.service = service;
    this.providerEmail= provideremail;
    this.ownerEmail=ownerEmail;
    this.numofpets = numofpets;
    this.address = address;
    this.dateTime = dateTime;
  }
  Map<String, dynamic> serialize(){
      return <String,dynamic>{
        PRICE: price,
        SERVICE: service,
        PROVIDEREMAIL: providerEmail,
        OWNEREMAIL: ownerEmail,
        NUMBEROFPETS: numofpets,
        ADDRESS: address,
        DATETIME: dateTime,
      };
  }
  static OrderService deserialize(Map<String,dynamic> document){
    return OrderService(
      price: document[PRICE],
      service: document[SERVICE],
      providerEmail: document[PROVIDEREMAIL],
      ownerEmail: document[OWNEREMAIL],
      numofpets: document[NUMBEROFPETS],
      address: document[ADDRESS],
      dateTime: document[DATETIME],
    );
  }

}