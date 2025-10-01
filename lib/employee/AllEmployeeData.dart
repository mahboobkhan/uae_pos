import 'employee_models.dart';

class AllEmployeeData {
  final String status;
  final List<Employee> employees;
  final List<Profile> allProfiles;
  final List<UserAccess> allUserAccess;
  final List<EmployeeType> allEmployeeTypes;
  final List<Designation> allDesignations;
  final List<Bank> allBanks;
  final List<BankAccount> allUserBankAccounts;
  final List<Tag> allTags;
  final List<Salary> allMonthlySalaries;
  final List<PaymentMethod> allPaymentMethods;

  AllEmployeeData({
    required this.status,
    required this.employees,
    required this.allProfiles,
    required this.allUserAccess,
    required this.allEmployeeTypes,
    required this.allDesignations,
    required this.allBanks,
    required this.allUserBankAccounts,
    required this.allTags,
    required this.allMonthlySalaries,
    required this.allPaymentMethods,
  });

  factory AllEmployeeData.fromJson(Map<String, dynamic> json) {
    return AllEmployeeData(
      status: json['status'] ?? '',
      employees:
          (json['employees'] as List<dynamic>?)
              ?.map((x) => Employee.fromJson(x))
              .toList() ??
          [],
      allProfiles:
          (json['all_profiles'] as List<dynamic>?)
              ?.map((x) => Profile.fromJson(x))
              .toList() ??
          [],
      allUserAccess:
          (json['all_user_access'] as List<dynamic>?)
              ?.map((x) => UserAccess.fromJson(x))
              .toList() ??
          [],
      allEmployeeTypes:
          (json['all_employee_types'] as List<dynamic>?)
              ?.map((x) => EmployeeType.fromJson(x))
              .toList() ??
          [],
      allDesignations:
          (json['all_designations'] as List<dynamic>?)
              ?.map((x) => Designation.fromJson(x))
              .toList() ??
          [],
      allBanks:
          (json['all_banks'] as List<dynamic>?)
              ?.map((x) => Bank.fromJson(x))
              .toList() ??
          [],
      allUserBankAccounts:
          (json['all_user_bank_accounts'] as List<dynamic>?)
              ?.map((x) => BankAccount.fromJson(x))
              .toList() ??
          [],
      allTags:
          (json['all_tags'] as List<dynamic>?)
              ?.map((x) => Tag.fromJson(x))
              .toList() ??
          [],
      allMonthlySalaries:
          (json['all_monthly_salaries'] as List<dynamic>?)
              ?.map((x) => Salary.fromJson(x))
              .toList() ??
          [],
      allPaymentMethods:
          (json['all_payment_methods'] as List<dynamic>?)
              ?.map((x) => PaymentMethod.fromJson(x))
              .toList() ??
          [],
    );
  }
}
