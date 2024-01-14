import 'package:flutter/material.dart';
import 'package:flutter_path_finder_algorithms/path_finder_painter.dart';
import 'package:flutter_path_finder_algorithms/path_finders/astar_path_finder.dart';
import 'package:flutter_path_finder_algorithms/path_finders/base_path_finder.dart';
import 'package:flutter_path_finder_algorithms/path_finders/node.dart';

const int size = 15;
const int walls = 10;

const List<Offset> wallList = <Offset>[
  Offset(2, 1),
  Offset(3, 1),
  Offset(4, 1),
  Offset(5, 1),
  Offset(2, 4),
  Offset(3, 4),
  Offset(4, 4),
  Offset(5, 4),
  Offset(2, 7),
  Offset(3, 7),
  Offset(4, 7),
  Offset(5, 7),
  Offset(2, 10),
  Offset(3, 10),
  Offset(4, 10),
  Offset(5, 10),
  Offset(2, 13),
  Offset(3, 13),
  Offset(4, 13),
  Offset(5, 13),
  Offset(7, 4),
  Offset(8, 4),
];

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Offset startPosition = Offset(8, 3);
    const Offset endPosition = Offset(4,6);

    final List<List<Node>> nodes =
        _generateNodes(size, wallList, startPosition, endPosition);

    final screenSize = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SizedBox(
            width: screenSize.width,
            height: screenSize.width,
            child: _drawMap(
              Node.cloneList(nodes),
              AStarPathFinder(),
              startPosition,
              endPosition,
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawMap(
    List<List<Node>> nodes,
    BasePathFinder pathFinder,
    Offset startPosition,
    Offset endPosition,
  ) {
    final int startX = startPosition.dx.floor();
    final int startY = startPosition.dy.floor();

    final int endX = endPosition.dx.floor();
    final int endY = endPosition.dy.floor();

    final Node start = nodes[startX][startY];
    final Node end = nodes[endX][endY];

    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        Text(
          '${pathFinder.name}',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        StreamBuilder<List<List<Node>>>(
          stream: pathFinder(nodes, start, end),
          initialData: nodes,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<List<Node>>> finderSnapshot,
          ) =>
              StreamBuilder<List<Node>>(
            stream: pathFinder.getPath(end),
            initialData: const <Node>[],
            builder: (
              BuildContext context,
              AsyncSnapshot<List<Node>> pathSnapshot,
            ) =>
                CustomPaint(
              size: const Size(350, 350),
              painter: PathFinderPainter(
                finderSnapshot.data!,
                pathSnapshot.data!,
                start,
                end,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<List<Node>> _generateNodes(
    int size,
    List<Offset> wallList,
    Offset start,
    Offset end,
  ) {
    final List<List<Node>> nodes = <List<Node>>[];

    for (int i = 0; i < size; i++) {
      final List<Node> row = <Node>[];

      for (int j = 0; j < size; j++) {
        row.add(Node(Offset(j.toDouble(), i.toDouble())));
      }

      nodes.add(row);
    }

    //Generate random wall
    // for (int i = 0; i < walls; i++) {
    //   final int row = Random().nextInt(size);
    //   final int column = Random().nextInt(size);
    //
    //   final int startX = start.dx.floor();
    //   final int startY = start.dy.floor();
    //
    //   final int endX = end.dx.floor();
    //   final int endY = end.dy.floor();
    //
    //   //Skip this turn and continue looping if auto generated wall is on the start or end.
    //   if (nodes[row][column] == nodes[startY][startX] ||
    //       nodes[row][column] == nodes[endY][endX]) {
    //     i--;
    //     continue;
    //   }
    //
    //   nodes[row][column].isWall = true;
    // }

    for (final Offset wall in wallList) {
      nodes[wall.dx.floor()][wall.dy.floor()].isWall = true;
    }

    return nodes;
  }
}
