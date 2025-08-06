class UserAccess {
  final int id;
  final String userId;
  final int dashboard;
  final int abc;
  final int employeesRole;
  final int projects;
  final int shortService;
  final int createOrders;
  final int serviceCategory;
  final int clients;
  final int company;
  final int individuals;
  final int financeHistory;
  final int employees;
  final int finance;
  final int bankDetail;
  final int banking;
  final int addPaymentMethod;
  final int statementHistory;
  final int officeExpenses;
  final int fixedOfficeExpanse;
  final int officeMaintenance;
  final int officeSupplies;
  final int miscellaneous;
  final int others;
  final int notifications;
  final int inbox;
  final int system;
  final int push;
  final int filesCashFlow;
  final int download;
  final int upload;
  final int settings;
  final int preferences;
  final int account;
  final int security;
  final String updatedAt;

  UserAccess({
    required this.id,
    required this.userId,
    required this.dashboard,
    required this.abc,
    required this.employeesRole,
    required this.projects,
    required this.shortService,
    required this.createOrders,
    required this.serviceCategory,
    required this.clients,
    required this.company,
    required this.individuals,
    required this.financeHistory,
    required this.employees,
    required this.finance,
    required this.bankDetail,
    required this.banking,
    required this.addPaymentMethod,
    required this.statementHistory,
    required this.officeExpenses,
    required this.fixedOfficeExpanse,
    required this.officeMaintenance,
    required this.officeSupplies,
    required this.miscellaneous,
    required this.others,
    required this.notifications,
    required this.inbox,
    required this.system,
    required this.push,
    required this.filesCashFlow,
    required this.download,
    required this.upload,
    required this.settings,
    required this.preferences,
    required this.account,
    required this.security,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'dashboard': dashboard,
      'abc': abc,
      'employeesRole': employeesRole,
      'projects': projects,
      'shortService': shortService,
      'createOrders': createOrders,
      'serviceCategory': serviceCategory,
      'clients': clients,
      'company': company,
      'individuals': individuals,
      'financeHistory': financeHistory,
      'employees': employees,
      'finance': finance,
      'bankDetail': bankDetail,
      'banking': banking,
      'addPaymentMethod': addPaymentMethod,
      'statementHistory': statementHistory,
      'officeExpenses': officeExpenses,
      'fixedOfficeExpanse': fixedOfficeExpanse,
      'officeMaintenance': officeMaintenance,
      'officeSupplies': officeSupplies,
      'miscellaneous': miscellaneous,
      'others': others,
      'notifications': notifications,
      'inbox': inbox,
      'system': system,
      'push': push,
      'filesCashFlow': filesCashFlow,
      'download': download,
      'upload': upload,
      'settings': settings,
      'preferences': preferences,
      'account': account,
      'security': security,
      'updatedAt': updatedAt,
    };
  }

  factory UserAccess.fromJson(Map<String, dynamic> json) {
    return UserAccess(
      id: json['id'],
      userId: json['userId'],
      dashboard: json['dashboard'],
      abc: json['abc'],
      employeesRole: json['employeesRole'],
      projects: json['projects'],
      shortService: json['shortService'],
      createOrders: json['createOrders'],
      serviceCategory: json['serviceCategory'],
      clients: json['clients'],
      company: json['company'],
      individuals: json['individuals'],
      financeHistory: json['financeHistory'],
      employees: json['employees'],
      finance: json['finance'],
      bankDetail: json['bankDetail'],
      banking: json['banking'],
      addPaymentMethod: json['addPaymentMethod'],
      statementHistory: json['statementHistory'],
      officeExpenses: json['officeExpenses'],
      fixedOfficeExpanse: json['fixedOfficeExpanse'],
      officeMaintenance: json['officeMaintenance'],
      officeSupplies: json['officeSupplies'],
      miscellaneous: json['miscellaneous'],
      others: json['others'],
      notifications: json['notifications'],
      inbox: json['inbox'],
      system: json['system'],
      push: json['push'],
      filesCashFlow: json['filesCashFlow'],
      download: json['download'],
      upload: json['upload'],
      settings: json['settings'],
      preferences: json['preferences'],
      account: json['account'],
      security: json['security'],
      updatedAt: json['updatedAt'],
    );
  }
}

class EmployeeType {
  final int id;
  final String userId;
  final String employeeType;
  final String createdBy;
  final String createdDate;

  EmployeeType({
    required this.id,
    required this.userId,
    required this.employeeType,
    required this.createdBy,
    required this.createdDate,
  });

  factory EmployeeType.fromJson(Map<String, dynamic> json) {
    return EmployeeType(
      id: json['id'],
      userId: json['userId'],
      employeeType: json['employeeType'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
    );
  }
}

class Designation {
  final int id;
  final String userId;
  final String designations;
  final String createdBy;
  final String createdDate;

  Designation({
    required this.id,
    required this.userId,
    required this.designations,
    required this.createdBy,
    required this.createdDate,
  });

  factory Designation.fromJson(Map<String, dynamic> json) {
    return Designation(
      id: json['id'],
      userId: json['userId'],
      designations: json['designations'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
    );
  }
}

class Bank {
  final int id;
  final String userId;
  final String bankName;
  final String createdBy;
  final String createdDate;

  Bank({
    required this.id,
    required this.userId,
    required this.bankName,
    required this.createdBy,
    required this.createdDate,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      userId: json['userId'],
      bankName: json['bankName'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
    );
  }
}

class BankAccount {
  final int id;
  final String userId;
  final String bankName;
  final String branchCode;
  final String bankAddress;
  final String titleName;
  final String bankAccountNumber;
  final String ibanNumber;
  final String contactNumber;
  final String emailId;
  final String additionalNote;
  final String createdBy;
  final String createdDate;

  BankAccount({
    required this.id,
    required this.userId,
    required this.bankName,
    required this.branchCode,
    required this.bankAddress,
    required this.titleName,
    required this.bankAccountNumber,
    required this.ibanNumber,
    required this.contactNumber,
    required this.emailId,
    required this.additionalNote,
    required this.createdBy,
    required this.createdDate,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'],
      userId: json['userId'],
      bankName: json['bankName'],
      branchCode: json['branchCode'],
      bankAddress: json['bankAddress'],
      titleName: json['titleName'],
      bankAccountNumber: json['bankAccountNumber'],
      ibanNumber: json['ibanNumber'],
      contactNumber: json['contactNumber'],
      emailId: json['emailId'],
      additionalNote: json['additionalNote'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
    );
  }
}

class Tag {
  final int id;
  final String userId;
  final String tagName;
  final String createdByUser;
  final String createdDate;
  final String lastUpdatedDate;

  Tag({
    required this.id,
    required this.userId,
    required this.tagName,
    required this.createdByUser,
    required this.createdDate,
    required this.lastUpdatedDate,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      userId: json['userId'],
      tagName: json['tagName'],
      createdByUser: json['createdByUser'],
      createdDate: json['createdDate'],
      lastUpdatedDate: json['lastUpdatedDate'],
    );
  }
}

class Salary {
  final int id;
  final String userId;
  final String salaryMonth;
  final String totalSalary;
  final String advanceSalary;
  final String bonus;
  final String fineDeduction;
  final String remainingSalary;
  final String status;
  final String lastModified;

  Salary({
    required this.id,
    required this.userId,
    required this.salaryMonth,
    required this.totalSalary,
    required this.advanceSalary,
    required this.bonus,
    required this.fineDeduction,
    required this.remainingSalary,
    required this.status,
    required this.lastModified,
  });

  factory Salary.fromJson(Map<String, dynamic> json) {
    return Salary(
      id: json['id'],
      userId: json['userId'],
      salaryMonth: json['salaryMonth'],
      totalSalary: json['totalSalary'],
      advanceSalary: json['advanceSalary'],
      bonus: json['bonus'],
      fineDeduction: json['fineDeduction'],
      remainingSalary: json['remainingSalary'],
      status: json['status'],
      lastModified: json['lastModified'],
    );
  }
}

class PaymentMethod {
  final int id;
  final String userId;
  final String paymentMethod;
  final String createdBy;
  final String createdDate;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.paymentMethod,
    required this.createdBy,
    required this.createdDate,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      userId: json['userId'],
      paymentMethod: json['paymentMethod'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
    );
  }
}

class Profile {
  final int id;
  final String userId;
  final String employeeName;
  final String nickname;
  final String gender;
  final String personalPhone;
  final String alternatePhone;
  final String homePhone;
  final String workPermitNumber;
  final String emirateId;
  final String email;
  final int isUserActive;
  final String joiningDate;
  final String contractExpiryDate;
  final String dateOfBirth;
  final String bloodGroup;
  final String fatherName;
  final String religion;
  final String country;
  final String incrementAmount;
  final String nextIncrementDate;
  final String workingHours;
  final String physicalAddress;
  final String permanentAddress;
  final String extraNote1;
  final String extraNote2;
  final String maritalStatus;
  final int numberOfChildren;
  final String profileEditedByUsername;
  final String empDesignation;
  final String employeeType;
  final String tag;
  final String paymentMethod;
  final String? salary;
  final String createdDate;
  final String lastUpdatedDate;

  Profile({
    required this.id,
    required this.userId,
    required this.employeeName,
    required this.nickname,
    required this.gender,
    required this.personalPhone,
    required this.alternatePhone,
    required this.homePhone,
    required this.workPermitNumber,
    required this.emirateId,
    required this.email,
    required this.isUserActive,
    required this.joiningDate,
    required this.contractExpiryDate,
    required this.dateOfBirth,
    required this.bloodGroup,
    required this.fatherName,
    required this.religion,
    required this.country,
    required this.incrementAmount,
    required this.nextIncrementDate,
    required this.workingHours,
    required this.physicalAddress,
    required this.permanentAddress,
    required this.extraNote1,
    required this.extraNote2,
    required this.maritalStatus,
    required this.numberOfChildren,
    required this.profileEditedByUsername,
    required this.empDesignation,
    required this.employeeType,
    required this.tag,
    required this.paymentMethod,
    required this.salary,
    required this.createdDate,
    required this.lastUpdatedDate,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      userId: json['userId'],
      employeeName: json['employeeName'],
      nickname: json['nickname'],
      gender: json['gender'],
      personalPhone: json['personalPhone'],
      alternatePhone: json['alternatePhone'],
      homePhone: json['homePhone'],
      workPermitNumber: json['workPermitNumber'],
      emirateId: json['emirateId'],
      email: json['email'],
      isUserActive: json['isUserActive'],
      joiningDate: json['joiningDate'],
      contractExpiryDate: json['contractExpiryDate'],
      dateOfBirth: json['dateOfBirth'],
      bloodGroup: json['bloodGroup'],
      fatherName: json['fatherName'],
      religion: json['religion'],
      country: json['country'],
      incrementAmount: json['incrementAmount'],
      nextIncrementDate: json['nextIncrementDate'],
      workingHours: json['workingHours'],
      physicalAddress: json['physicalAddress'],
      permanentAddress: json['permanentAddress'],
      extraNote1: json['extraNote1'],
      extraNote2: json['extraNote2'],
      maritalStatus: json['maritalStatus'],
      numberOfChildren: json['numberOfChildren'],
      profileEditedByUsername: json['profileEditedByUsername'],
      empDesignation: json['empDesignation'],
      employeeType: json['employeeType'],
      tag: json['tag'],
      paymentMethod: json['paymentMethod'],
      salary: json['salary'],
      createdDate: json['createdDate'],
      lastUpdatedDate: json['lastUpdatedDate'],
    );
  }
}

class Employee {
  final int id;
  final String userId;
  final String employeeName;
  final String nickname;
  final String gender;
  final String personalPhone;
  final String alternatePhone;
  final String homePhone;
  final String workPermitNumber;
  final String emirateId;
  final String email;
  final int isUserActive;
  final String joiningDate;
  final String contractExpiryDate;
  final String dateOfBirth;
  final String bloodGroup;
  final String fatherName;
  final String religion;
  final String country;
  final String incrementAmount;
  final String nextIncrementDate;
  final String workingHours;
  final String physicalAddress;
  final String permanentAddress;
  final String extraNote1;
  final String extraNote2;
  final String maritalStatus;
  final int numberOfChildren;
  final String profileEditedByUsername;
  final String empDesignation;
  final String employeeType;
  final String tag;
  final String paymentMethod;
  final String? salary;
  final String createdDate;
  final String lastUpdatedDate;
  final UserAccess? access;
  final Salary? salaryCurrentMonth;
  final List<Tag> allTags;
  final List<EmployeeType> allEmployeeTypes;
  final List<Designation> allDesignations;
  final List<PaymentMethod> allPaymentMethods;
  final List<BankAccount> allBankAccounts;

  Employee({
    required this.id,
    required this.userId,
    required this.employeeName,
    required this.nickname,
    required this.gender,
    required this.personalPhone,
    required this.alternatePhone,
    required this.homePhone,
    required this.workPermitNumber,
    required this.emirateId,
    required this.email,
    required this.isUserActive,
    required this.joiningDate,
    required this.contractExpiryDate,
    required this.dateOfBirth,
    required this.bloodGroup,
    required this.fatherName,
    required this.religion,
    required this.country,
    required this.incrementAmount,
    required this.nextIncrementDate,
    required this.workingHours,
    required this.physicalAddress,
    required this.permanentAddress,
    required this.extraNote1,
    required this.extraNote2,
    required this.maritalStatus,
    required this.numberOfChildren,
    required this.profileEditedByUsername,
    required this.empDesignation,
    required this.employeeType,
    required this.tag,
    required this.paymentMethod,
    this.salary,
    required this.createdDate,
    required this.lastUpdatedDate,
    this.access,
    this.salaryCurrentMonth,
    required this.allTags,
    required this.allEmployeeTypes,
    required this.allDesignations,
    required this.allPaymentMethods,
    required this.allBankAccounts,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      userId: json['userId'],
      employeeName: json['employeeName'],
      nickname: json['nickname'],
      gender: json['gender'],
      personalPhone: json['personalPhone'],
      alternatePhone: json['alternatePhone'],
      homePhone: json['homePhone'],
      workPermitNumber: json['workPermitNumber'],
      emirateId: json['emirateId'],
      email: json['email'],
      isUserActive: json['isUserActive'],
      joiningDate: json['joiningDate'],
      contractExpiryDate: json['contractExpiryDate'],
      dateOfBirth: json['dateOfBirth'],
      bloodGroup: json['bloodGroup'],
      fatherName: json['fatherName'],
      religion: json['religion'],
      country: json['country'],
      incrementAmount: json['incrementAmount'],
      nextIncrementDate: json['nextIncrementDate'],
      workingHours: json['workingHours'],
      physicalAddress: json['physicalAddress'],
      permanentAddress: json['permanentAddress'],
      extraNote1: json['extraNote1'],
      extraNote2: json['extraNote2'],
      maritalStatus: json['maritalStatus'],
      numberOfChildren: json['numberOfChildren'],
      profileEditedByUsername: json['profileEditedByUsername'],
      empDesignation: json['empDesignation'],
      employeeType: json['employeeType'],
      tag: json['tag'],
      paymentMethod: json['paymentMethod'],
      salary: json['salary'],
      createdDate: json['createdDate'],
      lastUpdatedDate: json['lastUpdatedDate'],
      access:
          json['access'] != null ? UserAccess?.fromJson(json['access']) : null,
      salaryCurrentMonth:
          json['salaryCurrentMonth'] != null
              ? Salary?.fromJson(json['salaryCurrentMonth'])
              : null,
      allTags: List<Tag>.from(json['allTags'].map((x) => Tag.fromJson(x))),
      allEmployeeTypes: List<EmployeeType>.from(
        json['allEmployeeTypes'].map((x) => EmployeeType.fromJson(x)),
      ),
      allDesignations: List<Designation>.from(
        json['allDesignations'].map((x) => Designation.fromJson(x)),
      ),
      allPaymentMethods: List<PaymentMethod>.from(
        json['allPaymentMethods'].map((x) => PaymentMethod.fromJson(x)),
      ),
      allBankAccounts: List<BankAccount>.from(
        json['allBankAccounts'].map((x) => BankAccount.fromJson(x)),
      ),
    );
  }
}
