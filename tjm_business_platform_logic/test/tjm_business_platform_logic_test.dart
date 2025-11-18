// import 'package:test/test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mockito/annotations.dart';
// import 'package:intl/intl.dart';
// import 'package:tjm_business_platform_logic/core/action_result.dart';
// import 'package:tjm_business_platform_logic/core/model/customer.dart';
// import 'package:tjm_business_platform_logic/core/model/platform_user.dart';
// import 'package:tjm_business_platform_logic/core/model/report.dart';
// import 'package:tjm_business_platform_logic/core/role.dart';
// import 'package:tjm_business_platform_logic/data/auth_repository.dart';
// import 'package:tjm_business_platform_logic/data/data_repository.dart';
// import 'package:tjm_business_platform_logic/domain/auth.dart';
// import 'package:tjm_business_platform_logic/domain/data.dart';

// // run: [dart run build_runner build] to generate tjm_business_platform_logic_test.mocks.dart

// @GenerateMocks([AuthRepository, DataRepository])
// import 'tjm_business_platform_logic_test.mocks.dart';

// double parseGsToDouble(String amount) {
//   final cleaned = amount.replaceAll('.', '').replaceAll(',', '');
//   return double.tryParse(cleaned) ?? 0.0;
// }

// String formatDoubleToGs(double amount) {
//   final formatter = NumberFormat('#,###', 'es_PY');
//   return formatter.format(amount).replaceAll(',', '.');
// }

// void main() {
//   late MockAuthRepository mockAuthRepo;
//   late MockDataRepository mockDataRepo;

//   setUp(() {
//     mockAuthRepo = MockAuthRepository();
//     mockDataRepo = MockDataRepository();

//     Auth().auth = mockAuthRepo;
//     Data().appDatabase = mockDataRepo;

//     reset(mockAuthRepo);
//     reset(mockDataRepo);
//   });

//   group('Auth Logic Tests', () {
//     test('isLoggedIn returns true when the repository indicates logged in', () {
//       // 1. Configurar el comportamiento del Mock
//       when(mockAuthRepo.isLoggedIn()).thenReturn(true);

//       // 2. Ejecutar la acción de dominio
//       final result = Auth().isLoggedIn();

//       // 3. Verificar el resultado
//       expect(result, isTrue);

//       // 4. Verificar que se llamó al método del repositorio
//       verify(mockAuthRepo.isLoggedIn()).called(1);
//     });

//     test('login returns ActionResult.ok on successful login', () async {
//       // 1. Configurar el comportamiento del Mock
//       when(
//         mockAuthRepo.login('test@example.com', 'password123'),
//       ).thenAnswer((_) async => ActionResult.ok);

//       // 2. Ejecutar la acción
//       final result = await Auth().login('test@example.com', 'password123');

//       // 3. Verificar el resultado y la interacción
//       expect(result, ActionResult.ok);
//       verify(mockAuthRepo.login('test@example.com', 'password123')).called(1);
//     });

//     test('getUserProfile returns a PlatformUser on success', () async {
//       // Data de prueba
//       final testUser = PlatformUser(
//         id: '123',
//         name: 'John',
//         lastName: 'Doe',
//         email: 'johndoe@test.com',
//         phoneNumber: '555-1234',
//         userRole: Role.admin,
//       );

//       // 1. Configurar el comportamiento del Mock
//       when(mockAuthRepo.getUserProfile()).thenAnswer((_) async => testUser);

//       // 2. Ejecutar la acción
//       final result = await Auth().getUserProfile();

//       // 3. Verificar el resultado
//       expect(result, isA<PlatformUser>());
//       expect(result?.email, 'johndoe@test.com');
//       verify(mockAuthRepo.getUserProfile()).called(1);
//     });

//     test('logout returns ActionResult.ok', () async {
//       // 1. Configurar el comportamiento del Mock
//       when(mockAuthRepo.logout()).thenAnswer((_) async => ActionResult.ok);

//       // 2. Ejecutar la acción
//       final result = await Auth().logout();

//       // 3. Verificar el resultado
//       expect(result, ActionResult.ok);
//       verify(mockAuthRepo.logout()).called(1);
//     });
//   });

//   // --- Tests para la Clase Data (Lógica de Datos/Reportes) ---
//   group('Data Logic Tests', () {
//     final tReport = Report(
//       id: 'r1',
//       author: 'user1',
//       customerId: 'c1',
//       customerName: 'Customer A',
//       detail: 'Detalle',
//       price: 150000.0,
//       isPending: false,
//       isPaid: true,
//     );
//     final tCustomer = Customer(
//       id: 'c1',
//       name: 'Customer A',
//       phoneNumber: '999',
//       works: [tReport],
//     );

//     test('getAllReports returns a list of reports', () async {
//       // 1. Configurar el comportamiento del Mock
//       when(mockDataRepo.getAllReports()).thenAnswer((_) async => [tReport]);

//       // 2. Ejecutar la acción
//       final result = await Data().getAllReports();

//       // 3. Verificar el resultado
//       expect(result, isA<List<Report>>());
//       expect(result.length, 1);
//       expect(result.first.id, 'r1');
//       verify(mockDataRepo.getAllReports()).called(1);
//     });

//     test('addNewReport returns ActionResult.ok on success', () async {
//       // 1. Configurar el comportamiento del Mock
//       when(
//         mockDataRepo.addNewReport(tReport),
//       ).thenAnswer((_) async => ActionResult.ok);

//       // 2. Ejecutar la acción
//       final result = await Data().addNewReport(tReport);

//       // 3. Verificar el resultado
//       expect(result, ActionResult.ok);
//       verify(mockDataRepo.addNewReport(tReport)).called(1);
//     });

//     test('getTotalIncome returns the correct sum', () async {
//       // 1. Configurar el comportamiento del Mock
//       when(mockDataRepo.getTotalIncome()).thenAnswer((_) async => 550000.0);

//       // 2. Ejecutar la acción
//       final result = await Data().getTotalIncome();

//       // 3. Verificar el resultado
//       expect(result, 550000.0);
//       verify(mockDataRepo.getTotalIncome()).called(1);
//     });

//     test(
//       'findCustomersByNameFragment calls repository with correct parameter',
//       () async {
//         // 1. Configurar el comportamiento del Mock
//         when(
//           mockDataRepo.findCustomersByNameFragment('Cus'),
//         ).thenAnswer((_) async => ['Customer A', 'Customer B']);

//         // 2. Ejecutar la acción
//         final result = await Data().findCustomersByNameFragment('Cus');

//         // 3. Verificar el resultado
//         expect(result.length, 2);
//         expect(result.first, 'Customer A');
//         // Asegurar que el método del repositorio fue llamado con el fragmento correcto
//         verify(mockDataRepo.findCustomersByNameFragment('Cus')).called(1);
//       },
//     );

//     test(
//       'editCustomer returns ActionResult.error when repository fails',
//       () async {
//         // 1. Configurar el comportamiento del Mock para que falle
//         when(
//           mockDataRepo.editCustomer(tCustomer),
//         ).thenAnswer((_) async => ActionResult.error);

//         // 2. Ejecutar la acción
//         final result = await Data().editCustomer(tCustomer);

//         // 3. Verificar el resultado
//         expect(result, ActionResult.error);
//         verify(mockDataRepo.editCustomer(tCustomer)).called(1);
//       },
//     );

//     // Se podrían añadir más tests para getAllCustomers, addNewCustomer, etc.
//   });

//   // --- Tests para Funciones Utilitarias (Formato de Números) ---
//   group('Utility Functions Tests (parseGsToDouble & formatDoubleToGs)', () {
//     test('parseGsToDouble correctly converts 125.000 to 125000.0', () {
//       final result = parseGsToDouble('125.000');
//       expect(result, 125000.0);
//     });

//     test(
//       'parseGsToDouble handles currency with comma (1.250.000,50) correctly by ignoring it',
//       () {
//         // La implementación actual solo maneja '.'. Si se espera manejar coma decimal, la lógica debe ajustarse.
//         // Basado en tu lógica: '1.250.000,50' -> '125000050' -> 125000050.0
//         final result = parseGsToDouble('1.250.000,50');
//         expect(result, 125000050.0);
//       },
//     );

//     test('parseGsToDouble returns 0.0 for invalid input', () {
//       final result = parseGsToDouble('abc');
//       expect(result, 0.0);
//     });

//     test('formatDoubleToGs correctly formats 125000.0 to "125.000"', () {
//       final result = formatDoubleToGs(125000.0);
//       expect(result, '125.000');
//     });

//     test(
//       'formatDoubleToGs correctly formats large number 1234567.89 to "1.234.567,89" (or similar)',
//       () {
//         // El formato "#,###" no incluye decimales por defecto.
//         final result = formatDoubleToGs(1234567.89);
//         // NumberFormat('#,###', 'es_PY') formatea a "1.234.568" (redondeado),
//         // y luego .replaceAll(',', '.') lo convierte a "1.234.568"
//         // Si quieres decimales, el formato debería ser '#,##0.00' y ajustar el replaceAll
//         expect(result, '1.234.568');
//       },
//     );
//   });
// }
