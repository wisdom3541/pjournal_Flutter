import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'PJournal',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'PJournal'),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  //textField controllers
  final titleController = TextEditingController();
  final noteController = TextEditingController();

  bool editing = false;

  int selectedIndex = 0;

  List<Note> noteList = [];

  // final noteList = List.generate(
  //     20,
  //     (i) => const Note(
  //         title: "This is Title",
  //         noteContent:
  //             "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."));

  void updateNavPage(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void clearList() {
    noteList.clear();
    notifyListeners();
  }

  void isEditing() {
    if (titleController.text.isEmpty || noteController.text.isEmpty) {
      editing = false;
    } else {
      editing = true;
    }
    notifyListeners();
  }

  void notEditing() {
    //if (titleController.text.isEmpty)
    editing = false;
    notifyListeners();
  }

  void saveNote(Note note) {
    noteList.add(note);
    updateNavPage(1);
    notEditing();
    notifyListeners();
    resetFields();
  }

  void resetFields() {
    titleController.clear();
    noteController.clear();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF191C1A),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: const SplashScreen());
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          color: const Color.fromRGBO(24, 28, 29, 1),
          child: const Text(
            "PJournal",
            style: TextStyle(fontSize: 40.0, color: Colors.cyan),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        const SplashButton()
      ]),
    );
  }
}

class MainPageContainer extends StatelessWidget {
  const MainPageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context, listen: true);
    var selectedIndex = appState.selectedIndex;

    Widget page = home(context);
    switch (selectedIndex) {
      case 0:
        page = home(context);
        break;

      case 1:
        page = const ListPage();
        break;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF191C1A),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(24, 28, 29, 1),
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "PJournal",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[saveButton()],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromRGBO(32, 43, 47, 1),
        destinations: bottomNavDestination,
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          if (value == 0) {
            appState.isEditing();
            // print("hhome");
            // print(appState.editing.toString());
          } else {
            appState.notEditing();
            // print("list");
            // print(appState.editing.toString());
          }
          appState.updateNavPage(value);
        },
      ),
      body: Container(
        child: page,
      ),
    );
  }
}

Widget saveButton() {
  return Consumer<MyAppState>(builder: (context, appState, child) {
    if (appState.editing == true) {
      return IconButton(
        onPressed: () => {
          appState.saveNote(Note(
              title: appState.titleController.text,
              noteContent: appState.noteController.text)),
        },
        alignment: AlignmentDirectional.centerEnd,
        icon: const Icon(
          Icons.save_outlined,
          semanticLabel: "Save",
        ),
        color: Colors.white,
        tooltip: "Save",
      );
    } else {
      return const SizedBox(
        height: 1,
      );
    }
  });
}

var bottomNavDestination = const [
  NavigationDestination(icon: Icon(Icons.edit), label: "Write"),
  NavigationDestination(icon: Icon(Icons.list), label: "List")
];

Widget home(BuildContext context) {
  final appState = Provider.of<MyAppState>(context, listen: false);
  return Scaffold(
    backgroundColor: const Color(0xFF191C1A),
    body: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 0,
          child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: appState.titleController,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: "Enter a Title....",
                    hintStyle: const TextStyle(color: Colors.white70),
                    //filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                onChanged: (text) {
                  appState.isEditing();
                },
              )),
        ),
        const Divider(height: 3.0),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: appState.noteController,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                  fillColor: Color.fromRGBO(64, 72, 75, 1),
                  filled: true,
                  hintText: "Write a note",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              maxLines: null,
              expands: true,
              onChanged: (text) {
                appState.isEditing();
              },
            ),
          ),
        )
      ],
    ),
  );
}

class ListPage extends StatelessWidget {
  const ListPage({super.key});
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context, listen: true);
    List<Note> notes = appState.noteList;
    return Scaffold(
        backgroundColor: const Color.fromRGBO(24, 28, 29, 1),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Note List",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  if (notes.isEmpty) {
                    // appState.clearList();
                    return const Center(
                      child: Text(
                        "No Note as been added",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30.0, color: Colors.white),
                      ),
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: Colors.blueGrey,
                        contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        title: Text(
                          notes[index].title,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white70),
                        ),
                        subtitle: Text(
                          notes[index].noteContent,
                          maxLines: 1,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotePage(
                                      title: notes[index].title,
                                      content: notes[index].noteContent)));
                        },
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ));
  }
}

//Card widget for list
Widget listCard(String title, String description) {
  return Card(
    color: Colors.blueGrey,
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 25, color: Colors.white),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            description,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    ),
  );
}

//data class for note
class Note {
  const Note({required this.title, required this.noteContent});

  final String title;
  final String noteContent;
}

// final noteList = List.generate(
//     5,
//     (i) =>
//         const Note(title: "This is Title", noteContent: "This is description"));

class SplashButton extends StatelessWidget {
  const SplashButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        color: const Color.fromRGBO(91, 213, 250, 1),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainPageContainer()));
        },
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: const Text(
            "Let's Write...",
          ),
        ));
  }
}

class NotePage extends StatelessWidget {
  const NotePage({super.key, required this.title, required this.content});

  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(24, 28, 29, 1),
      appBar: AppBar(
        // leading: IconButton(
        //     onPressed: () {
        //     },
        //     icon: const Icon(
        //       Icons.arrow_back,
        //       //size: 30,
        //     )),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(32, 43, 47, 1),
        title: const Text(
          "PNote", style: TextStyle(fontSize: 25, color: Colors.white),
          // textAlign: TextAlign.center,
        ),
        automaticallyImplyLeading: true,
        //actions: <Widget>[saveButton()],
      ),
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                title,
                style: const TextStyle(fontSize: 30, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              textAlign: TextAlign.justify,
              softWrap: true,
              content,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget manualAppBar() {
//   return Row(
//     children: [
//       IconButton(
//           onPressed: () {},
//           icon: Icon(
//             Icons.arrow_back,
//             //size: 30,
//           )),
//       const Expanded(
//         flex: 1,
//         child: Text(
//             style: TextStyle(fontSize: 25),
//             textAlign: TextAlign.center,
//             "PNote"),
//       )
//     ],
//   );
// }
