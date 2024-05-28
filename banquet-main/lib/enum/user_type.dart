enum UserType {admin, banquetOwner, customer}

extension UserTypeExetension on UserType{

  String get getName{
    switch(this){
      case UserType.admin:
        return 'Admin';
      case UserType.banquetOwner:
        return 'Banquet Owner';
      case UserType.customer:
        return 'Customer';
    }
  }
}