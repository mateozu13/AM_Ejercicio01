import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final formKey = GlobalKey<FormState>();

  StringBuffer valueA = StringBuffer();
  StringBuffer valueB = StringBuffer();
  String result = '';
  String title = '';
  String operation = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              color: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Color(0xff050060))),
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreen,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(color: Colors.white),
            ),
          )),
      title: 'Ejercicio 01',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ejercicio 01'),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                const Text(
                  'Ingresa un numero A y un número B para la división (A / B)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                // numero A
                TextFormField(
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                  decoration: CustomInputDecoration('Número A - dividendo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese un número';
                    } else if (value.length > 150) {
                      return 'El número ingresado supera el máximo permitido';
                    } else if (value.contains('.')) {
                      return 'El número debe ser entero';
                    }
                    return null;
                  },
                  onSaved: (newValue) => valueA.write(newValue),
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(
                  height: 15,
                ),

                // numero B
                TextFormField(
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                  decoration: CustomInputDecoration('Número B - divisor'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese un número';
                    } else if (value.length > 150) {
                      return 'El número ingresado supera el máximo permitido';
                    } else if (value.contains('.')) {
                      return 'El número debe ser entero';
                    } else if (value == '0') {
                      return 'No se puede dividir por 0';
                    }
                    return null;
                  },
                  onSaved: (newValue) => valueB.write(newValue),
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(
                  height: 15,
                ),

                // button
                ElevatedButton(
                    onPressed: () => validateForm(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Calcular división')),

                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(operation,
                      style: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 14)),
                ),
                const SizedBox(
                  height: 15,
                ),
                // title
                Center(
                  child: Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 16)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(result,
                      style: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateForm(BuildContext context) {
    SnackBar snackBar;
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      print('Dividendo: $valueA');
      print('Divisor: $valueB');

      calcularDivision();

      valueA.clear();
      valueB.clear();
    } else {
      snackBar = const SnackBar(
        content: Text('Los datos ingresados son incorrectos'),
        backgroundColor: Colors.redAccent,
      );
      // mostrar snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // calculate
  void calcularDivision() {
    setState(() {});
    title = 'Resultado:';
    operation = '$valueA ÷ $valueB';

    // variables division
    StringBuffer dividendo = valueA;
    StringBuffer divisor = valueB;
    bool negativeA = dividendo.toString().contains('-');
    bool negativeB = divisor.toString().contains('-');

    if ((negativeA && !negativeB) || (!negativeA && negativeB)) {
      result = '-${realizaProcesoDivision(dividendo, divisor, StringBuffer())}';
    } else {
      result = realizaProcesoDivision(dividendo, divisor, StringBuffer());
    }
  }
}

String realizaProcesoDivision(
    StringBuffer a, StringBuffer b, StringBuffer cociente) {
  StringBuffer resto = StringBuffer();

  if (toDouble(a) == 0) return '0';

  if (cociente.toString().contains('.') &&
      cociente.toString().split('.')[1].length == 6) {
    return cociente.toString();
  }

  if (toDouble(a) < toDouble(b)) {
    if (toDouble(a).toString().length <= toDouble(b).toString().length) {
      if (cociente.isEmpty) {
        cociente.write('0.');
        return realizaProcesoDivision(a, b, cociente);
      }
      if (!cociente.toString().contains('.')) {
        cociente.write('.');
        return realizaProcesoDivision(a, b, cociente);
      }
      a.write(0);
      if (toDouble(a).toString().length < toDouble(b).toString().length ||
          toDouble(a) < toDouble(b)) {
        cociente.write('0');
        return realizaProcesoDivision(
          a,
          b,
          cociente,
        );
      } else {
        return realizaProcesoDivision(
          a,
          b,
          cociente,
        );
      }
    }
  } else {
    num multiplicador = 1;
    while ((multiplicador * toDouble(b) <= toDouble(a))) {
      multiplicador++;
    }
    multiplicador--;
    cociente.write(multiplicador);
    var procesoResta = toDouble(a) - (multiplicador * toDouble(b));
    resto.write(procesoResta);

    if (toDouble(resto) == 0) {
      return cociente.toString();
    } else {
      StringBuffer newA = StringBuffer();
      newA.write(procesoResta);
      return realizaProcesoDivision(newA, b, cociente);
    }
  }
  return 'Error';
}

double toDouble(StringBuffer number) {
  String onlyNumber = number.toString().replaceAll(RegExp(r'[.-]'), '');
  return double.parse(onlyNumber);
}

class CustomInputDecoration extends InputDecoration {
  final String inputText;

  CustomInputDecoration(this.inputText)
      : super(
          fillColor: const Color(0xfff5f5f5),
          filled: true,
          hintText: inputText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.all(10),
        );
}
