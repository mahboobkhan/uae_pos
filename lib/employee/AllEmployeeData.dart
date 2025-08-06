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
      status: json['status'],
      employees: List<Employee>.from(
        json['employees'].map((x) => Employee.fromJson(x)),
      ),
      allProfiles: List<Profile>.from(
        json['all_profiles'].map((x) => Profile.fromJson(x)),
      ),
      allUserAccess: List<UserAccess>.from(
        json['all_user_access'].map((x) => UserAccess.fromJson(x)),
      ),
      allEmployeeTypes: List<EmployeeType>.from(
        json['all_employee_types'].map((x) => EmployeeType.fromJson(x)),
      ),
      allDesignations: List<Designation>.from(
        json['all_designations'].map((x) => Designation.fromJson(x)),
      ),
      allBanks: List<Bank>.from(json['all_banks'].map((x) => Bank.fromJson(x))),
      allUserBankAccounts: List<BankAccount>.from(
        json['all_user_bank_accounts'].map((x) => BankAccount.fromJson(x)),
      ),
      allTags: List<Tag>.from(json['all_tags'].map((x) => Tag.fromJson(x))),
      allMonthlySalaries: List<Salary>.from(
        json['all_monthly_salaries'].map((x) => Salary.fromJson(x)),
      ),
      allPaymentMethods: List<PaymentMethod>.from(
        json['all_payment_methods'].map((x) => PaymentMethod.fromJson(x)),
      ),
    );
  }
}
