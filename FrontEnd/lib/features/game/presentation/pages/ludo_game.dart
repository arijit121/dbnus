import 'dart:async';
import 'dart:math';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:flutter/material.dart';

import '../../../../navigation/custom_router/custom_route.dart';
import '../../../../shared/ui/atoms/text/custom_text.dart';

class LudoGamePage extends StatefulWidget {
  const LudoGamePage({super.key});

  @override
  State<LudoGamePage> createState() => _LudoGamePageState();
}

class _LudoGamePageState extends State<LudoGamePage>
    with SingleTickerProviderStateMixin {
  // Path Coordinates
  static const List<List<int>> pathCoords = [
    [6, 1],
    [6, 2],
    [6, 3],
    [6, 4],
    [6, 5],
    [5, 6],
    [4, 6],
    [3, 6],
    [2, 6],
    [1, 6],
    [0, 6],
    [0, 7],
    [0, 8],
    [1, 8],
    [2, 8],
    [3, 8],
    [4, 8],
    [5, 8],
    [6, 9],
    [6, 10],
    [6, 11],
    [6, 12],
    [6, 13],
    [6, 14],
    [7, 14],
    [8, 14],
    [8, 13],
    [8, 12],
    [8, 11],
    [8, 10],
    [8, 9],
    [9, 8],
    [10, 8],
    [11, 8],
    [12, 8],
    [13, 8],
    [14, 8],
    [14, 7],
    [14, 6],
    [13, 6],
    [12, 6],
    [11, 6],
    [10, 6],
    [9, 6],
    [8, 5],
    [8, 4],
    [8, 3],
    [8, 2],
    [8, 1],
    [8, 0],
    [7, 0],
    [6, 0]
  ];

  // Colors mapping: 0=Red, 1=Green, 2=Yellow, 3=Blue
  static const List<Color> playerColors = [
    Colors.redAccent,
    Colors.green,
    Colors.yellow,
    Colors.blueAccent,
  ];

  static const List<String> playerNames = ['Red', 'Green', 'Yellow', 'Blue'];

  // Safe spots index in absolute path
  static const List<int> safeSpots = [0, 8, 13, 21, 26, 34, 39, 47];

  // Game State
  List<List<int>> pawns = [
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
  ];

  int currentPlayer = 0;
  int currentDiceValue = 1;
  bool isDiceRolled = false;
  int? winner;

  // Settings
  List<int> activePlayers = [0, 1, 2, 3];
  List<int> aiPlayers = [];
  bool isGameSetup = false;

  // Animation
  late AnimationController _diceController;
  Timer? _diceTimer;

  @override
  void initState() {
    super.initState();
    _diceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSetupDialog();
    });
  }

  @override
  void dispose() {
    _diceController.dispose();
    _diceTimer?.cancel();
    super.dispose();
  }

  void _showSetupDialog({bool isEditSettings = false}) {
    int selectedTotalPlayers = 4;
    int selectedAiPlayers = 0;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1A1A2E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const CustomText('Game Setup',
                  color: Colors.white, size: 22, fontWeight: FontWeight.bold),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText('Total Players',
                      color: Colors.white, size: 16),
                  12.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [2, 3, 4].map((n) {
                      return ChoiceChip(
                        label: CustomText('$n',
                            color: selectedTotalPlayers == n
                                ? Colors.white
                                : Colors.grey),
                        selected: selectedTotalPlayers == n,
                        selectedColor: const Color(0xFF6C63FF),
                        backgroundColor: const Color(0xFF2A2A4A),
                        onSelected: (val) {
                          if (val) {
                            setDialogState(() {
                              selectedTotalPlayers = n;
                              if (selectedAiPlayers >= selectedTotalPlayers) {
                                selectedAiPlayers = selectedTotalPlayers - 1;
                              }
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  24.ph,
                  const CustomText('AI Opponents',
                      color: Colors.white, size: 16),
                  12.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        List.generate(selectedTotalPlayers, (i) => i).map((n) {
                      return ChoiceChip(
                        label: CustomText('$n',
                            color: selectedAiPlayers == n
                                ? Colors.white
                                : Colors.grey),
                        selected: selectedAiPlayers == n,
                        selectedColor: const Color(0xFFFF6B6B),
                        backgroundColor: const Color(0xFF2A2A4A),
                        onSelected: (val) {
                          if (val) setDialogState(() => selectedAiPlayers = n);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (!isEditSettings) {
                      CustomRoute.back();
                    }
                  },
                  child: const CustomText('Cancel', color: Colors.grey),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _initializeGame(selectedTotalPlayers, selectedAiPlayers);
                  },
                  child: const CustomText('Start Game', color: Colors.white),
                ),
              ],
            );
          });
        });
  }

  void _initializeGame(int total, int aiCount) {
    setState(() {
      winner = null;
      pawns = [
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
      ];

      if (total == 2) {
        activePlayers = [0, 2]; // Red and Yellow
      } else if (total == 3) {
        activePlayers = [0, 1, 2]; // Red, Green, Yellow
      } else {
        activePlayers = [0, 1, 2, 3];
      }

      currentPlayer = activePlayers.first;

      // Assign AI to the last 'aiCount' players
      aiPlayers = activePlayers.sublist(activePlayers.length - aiCount);

      isDiceRolled = false;
      currentDiceValue = 1;
      isGameSetup = true;
    });

    _checkAiTurn();
  }

  void _rollDice() {
    if (winner != null || isDiceRolled || _diceController.isAnimating || !isGameSetup) return;

    // Prevent human rolling if it's AI turn
    if (aiPlayers.contains(currentPlayer)) return;

    _performRoll();
  }

  void _performRoll() {
    setState(() {
      isDiceRolled = false;
    });

    _diceController.forward(from: 0);
    _diceTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) return;
      setState(() {
        currentDiceValue = Random().nextInt(6) + 1;
      });
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _diceTimer?.cancel();
      setState(() {
        currentDiceValue = Random().nextInt(6) + 1;
        isDiceRolled = true;

        // Check if any move is possible
        bool canMove = false;
        for (int pawnPos in pawns[currentPlayer]) {
          if (pawnPos == -1 && currentDiceValue == 6) canMove = true;
          if (pawnPos != -1 && pawnPos + currentDiceValue <= 56) canMove = true;
        }

        if (!canMove) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) _nextTurn();
          });
        } else if (aiPlayers.contains(currentPlayer)) {
          // AI must decide move
          Future.delayed(const Duration(milliseconds: 800), _executeAiMove);
        }
      });
    });
  }

  void _executeAiMove() {
    if (!mounted) return;

    int? bestPawnIdx;
    int highestPriority = -1; // 0=move forward, 1=out of home, 2=capture

    for (int i = 0; i < 4; i++) {
      int pos = pawns[currentPlayer][i];
      if (pos == -1 && currentDiceValue == 6) {
        if (highestPriority < 1) {
          highestPriority = 1;
          bestPawnIdx = i;
        }
      } else if (pos != -1 && pos + currentDiceValue <= 56) {
        int nextPos = pos + currentDiceValue;
        int absNextPos = _getAbsolutePosition(currentPlayer, nextPos);

        // Check capture
        bool canCapture = false;
        if (nextPos <= 50 && !safeSpots.contains(absNextPos)) {
          for (int p in activePlayers) {
            if (p != currentPlayer) {
              for (int otherPawn in pawns[p]) {
                if (otherPawn != -1 && otherPawn <= 50) {
                  if (_getAbsolutePosition(p, otherPawn) == absNextPos) {
                    canCapture = true;
                  }
                }
              }
            }
          }
        }

        if (canCapture) {
          highestPriority = 2;
          bestPawnIdx = i;
        } else if (highestPriority < 0) {
          highestPriority = 0;
          bestPawnIdx = i; // fallback valid move
        }
      }
    }

    if (bestPawnIdx != null) {
      _movePawn(currentPlayer, bestPawnIdx);
    } else {
      _nextTurn();
    }
  }

  void _nextTurn() {
    setState(() {
      if (currentDiceValue != 6) {
        int currentIndex = activePlayers.indexOf(currentPlayer);
        int nextIndex = (currentIndex + 1) % activePlayers.length;
        currentPlayer = activePlayers[nextIndex];
      }
      isDiceRolled = false;
    });

    _checkAiTurn();
  }

  void _checkAiTurn() {
    if (winner != null) return;
    if (aiPlayers.contains(currentPlayer)) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted && winner == null) _performRoll();
      });
    }
  }

  void _movePawn(int playerIdx, int pawnIdx) {
    // Only allow human moves if it's not AI's turn
    if (aiPlayers.contains(playerIdx) && isDiceRolled == false)
      return; // Wait for ai execution
    if (playerIdx != currentPlayer || !isDiceRolled) return;

    int currentPos = pawns[playerIdx][pawnIdx];

    if (currentPos == -1) {
      if (currentDiceValue == 6) {
        setState(() {
          pawns[playerIdx][pawnIdx] = 0;
          isDiceRolled = false;
        });
        _checkAiTurn();
      }
      return;
    }

    int nextPos = currentPos + currentDiceValue;
    if (nextPos <= 56) {
      setState(() {
        pawns[playerIdx][pawnIdx] = nextPos;

        if (nextPos <= 50) {
          int absolutePos = _getAbsolutePosition(playerIdx, nextPos);
          if (!safeSpots.contains(absolutePos)) {
            bool captured = false;
            for (int p in activePlayers) {
              if (p != playerIdx) {
                for (int i = 0; i < 4; i++) {
                  if (pawns[p][i] != -1 && pawns[p][i] <= 50) {
                    if (_getAbsolutePosition(p, pawns[p][i]) == absolutePos) {
                      pawns[p][i] = -1; // Captured! sent back home
                      captured = true;
                    }
                  }
                }
              }
            }
            if (captured) {
              currentDiceValue = 6; // Extra turn logic
            }
          }
        }

        if (pawns[playerIdx].every((p) => p == 56)) {
          winner = playerIdx;
          _showWinnerDialog(playerIdx);
          return;
        }

        _nextTurn();
      });
    }
  }

  void _showWinnerDialog(int winnerIdx) {
    String winnerName = ["Red", "Green", "Yellow", "Blue"][winnerIdx];
    Color winnerColor = playerColors[winnerIdx];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: const CustomText('Game Over!',
              color: Colors.white, size: 24, fontWeight: FontWeight.bold),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText('$winnerName wins!', color: winnerColor, size: 20, fontWeight: FontWeight.bold),
              16.ph,
              const CustomText('Would you like to play again?', color: Colors.white, size: 16),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                CustomRoute.back(); // exit
              },
              child: const CustomText('Exit', color: Colors.grey),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _showSetupDialog(); // prompt for setup again
              },
              child: const CustomText('Play Again', color: Colors.white),
            ),
          ],
        );
      }
    );
  }

  int _getAbsolutePosition(int playerIdx, int relativePos) {
    int startOffset = playerIdx * 13;
    return (startOffset + relativePos) % 52;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => CustomRoute.back(),
        ),
        title: const CustomText(
          'Ludo',
          color: Colors.white,
          fontWeight: FontWeight.w700,
          size: 20,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              _showSetupDialog(isEditSettings: true);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: isGameSetup
            ? Column(
                children: [
                  16.ph,
                  _buildTurnIndicator(),
                  16.ph,
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: CustomPaint(
                            painter: LudoBoardPainter(
                              activePlayers: activePlayers,
                              pawns: pawns,
                              playerColors: playerColors,
                              pathCoords: pathCoords,
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double cellWidth = constraints.maxWidth / 15;
                                double cellHeight = constraints.maxHeight / 15;
                                return Stack(
                                  children:
                                      _buildPawnWidgets(cellWidth, cellHeight),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildDiceArea(),
                  24.ph,
                ],
              )
            : const Center(
                child: CircularProgressIndicator(color: Color(0xFF6C63FF))),
      ),
    );
  }

  Widget _buildTurnIndicator() {
    bool isAi = aiPlayers.contains(currentPlayer);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: playerColors[currentPlayer].withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: playerColors[currentPlayer]),
      ),
      child: CustomText(
        '${playerNames[currentPlayer]}\'s Turn ${isAi ? "(AI)" : ""}',
        color: playerColors[currentPlayer],
        fontWeight: FontWeight.w700,
        size: 18,
      ),
    );
  }

  Widget _buildDiceArea() {
    return GestureDetector(
      onTap: _rollDice,
      child: AnimatedBuilder(
          animation: _diceController,
          builder: (context, child) {
            // Slight shake effect during roll
            double rotation = _diceController.isAnimating
                ? sin(_diceController.value * pi * 8) * 0.1
                : 0;
            return Transform.rotate(
              angle: rotation,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: (isDiceRolled || _diceController.isAnimating)
                      ? Colors.grey[800]
                      : playerColors[currentPlayer],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    if (!isDiceRolled && !_diceController.isAnimating)
                      BoxShadow(
                        color:
                            playerColors[currentPlayer].withValues(alpha: 0.5),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                  ],
                ),
                child: Center(
                  child: CustomText(
                    '$currentDiceValue',
                    color: Colors.white,
                    size: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
    );
  }

  List<Widget> _buildPawnWidgets(double w, double h) {
    List<Widget> widgets = [];

    Map<String, List<Map<String, dynamic>>> positionMap = {};

    for (int p in activePlayers) {
      for (int i = 0; i < 4; i++) {
        int relativePos = pawns[p][i];
        double x = 0, y = 0;

        if (relativePos == -1) {
          List<List<double>> baseOffsets = [
            [2.5, 2.5],
            [4.5, 2.5],
            [2.5, 4.5],
            [4.5, 4.5]
          ];
          if (p == 0) {
            x = baseOffsets[i][0] * w;
            y = baseOffsets[i][1] * h;
          } else if (p == 1) {
            x = (10 + baseOffsets[i][0] - 1) * w;
            y = baseOffsets[i][1] * h;
          } else if (p == 2) {
            x = (10 + baseOffsets[i][0] - 1) * w;
            y = (10 + baseOffsets[i][1] - 1) * h;
          } else if (p == 3) {
            x = baseOffsets[i][0] * w;
            y = (10 + baseOffsets[i][1] - 1) * h;
          }
        } else if (relativePos <= 50) {
          int absolutePos = _getAbsolutePosition(p, relativePos);
          x = pathCoords[absolutePos][1] * w + w / 2;
          y = pathCoords[absolutePos][0] * h + h / 2;
        } else {
          int homeOffset = relativePos - 50;
          if (homeOffset == 6) {
            x = 7.5 * w;
            y = 7.5 * h;
          } else {
            if (p == 0) {
              x = homeOffset * w + w / 2;
              y = 7 * h + h / 2;
            } else if (p == 1) {
              x = 7 * w + w / 2;
              y = homeOffset * h + h / 2;
            } else if (p == 2) {
              x = (14 - homeOffset) * w + w / 2;
              y = 7 * h + h / 2;
            } else if (p == 3) {
              x = 7 * w + w / 2;
              y = (14 - homeOffset) * h + h / 2;
            }
          }
        }

        String key = '${x}_$y';
        positionMap.putIfAbsent(key, () => []);
        positionMap[key]!.add({'p': p, 'i': i, 'x': x, 'y': y});
      }
    }

    positionMap.forEach((key, list) {
      for (int k = 0; k < list.length; k++) {
        var item = list[k];
        double offset =
            (list.length > 1) ? (k * 4.0 - (list.length * 2.0)) : 0.0;

        widgets.add(Positioned(
          left: item['x'] - w / 2.5 + offset,
          top: item['y'] - h / 2.5 + offset,
          width: w / 1.25,
          height: h / 1.25,
          child: GestureDetector(
            onTap: () => _movePawn(item['p'], item['i']),
            child: Container(
              decoration: BoxDecoration(
                  color: playerColors[item['p']],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 2))
                  ]),
            ),
          ),
        ));
      }
    });

    return widgets;
  }
}

class LudoBoardPainter extends CustomPainter {
  final List<int> activePlayers;
  final List<List<int>> pawns;
  final List<Color> playerColors;
  final List<List<int>> pathCoords;

  LudoBoardPainter({
    required this.activePlayers,
    required this.pawns,
    required this.playerColors,
    required this.pathCoords,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width / 15;
    double h = size.height / 15;
    Paint paint = Paint()..style = PaintingStyle.fill;
    Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black45
      ..strokeWidth = 1;

    // Draw home bases (grey out inactive ones)
    _drawHomeBase(canvas, 0, 0, w, h,
        activePlayers.contains(0) ? playerColors[0] : Colors.grey);
    _drawHomeBase(canvas, 9 * w, 0, w, h,
        activePlayers.contains(1) ? playerColors[1] : Colors.grey);
    _drawHomeBase(canvas, 9 * w, 9 * h, w, h,
        activePlayers.contains(2) ? playerColors[2] : Colors.grey);
    _drawHomeBase(canvas, 0, 9 * h, w, h,
        activePlayers.contains(3) ? playerColors[3] : Colors.grey);

    // Draw path cells
    for (int i = 0; i < 15; i++) {
      for (int j = 0; j < 15; j++) {
        if ((i < 6 && j < 6) ||
            (i > 8 && j < 6) ||
            (i < 6 && j > 8) ||
            (i > 8 && j > 8)) {
          continue;
        }

        if (i > 5 && i < 9 && j > 5 && j < 9) {
          continue;
        }

        Rect rect = Rect.fromLTWH(j * w, i * h, w, h);
        paint.color = Colors.white;

        // Start paths (grey out if inactive)
        if (i == 6 && j == 1)
          paint.color =
              activePlayers.contains(0) ? playerColors[0] : Colors.white;
        if (i == 1 && j == 8)
          paint.color =
              activePlayers.contains(1) ? playerColors[1] : Colors.white;
        if (i == 8 && j == 13)
          paint.color =
              activePlayers.contains(2) ? playerColors[2] : Colors.white;
        if (i == 13 && j == 6)
          paint.color =
              activePlayers.contains(3) ? playerColors[3] : Colors.white;

        if ((i == 2 && j == 6) ||
            (i == 6 && j == 12) ||
            (i == 12 && j == 8) ||
            (i == 8 && j == 2)) {
          paint.color = Colors.grey[300]!;
        }

        // Home columns
        if (i == 7 && j > 0 && j < 6)
          paint.color =
              activePlayers.contains(0) ? playerColors[0] : Colors.white;
        if (j == 7 && i > 0 && i < 6)
          paint.color =
              activePlayers.contains(1) ? playerColors[1] : Colors.white;
        if (i == 7 && j > 8 && j < 14)
          paint.color =
              activePlayers.contains(2) ? playerColors[2] : Colors.white;
        if (j == 7 && i > 8 && i < 14)
          paint.color =
              activePlayers.contains(3) ? playerColors[3] : Colors.white;

        canvas.drawRect(rect, paint);
        canvas.drawRect(rect, strokePaint);

        // Draw star on safe spots
        bool isSafeSpot = (i == 6 && j == 1) ||
            (i == 1 && j == 8) ||
            (i == 8 && j == 13) ||
            (i == 13 && j == 6) ||
            (i == 2 && j == 6) ||
            (i == 6 && j == 12) ||
            (i == 12 && j == 8) ||
            (i == 8 && j == 2);

        if (isSafeSpot) {
          _drawStar(canvas, rect.center.dx, rect.center.dy, w / 3, Colors.black26);
        }
      }
    }

    // Draw center triangles
    Path centerPath1 = Path()
      ..moveTo(6 * w, 6 * h)
      ..lineTo(9 * w, 6 * h)
      ..lineTo(7.5 * w, 7.5 * h)
      ..close();
    canvas.drawPath(
        centerPath1,
        Paint()
          ..color = activePlayers.contains(1) ? playerColors[1] : Colors.grey
          ..style = PaintingStyle.fill);

    Path centerPath2 = Path()
      ..moveTo(9 * w, 6 * h)
      ..lineTo(9 * w, 9 * h)
      ..lineTo(7.5 * w, 7.5 * h)
      ..close();
    canvas.drawPath(
        centerPath2,
        Paint()
          ..color = activePlayers.contains(2) ? playerColors[2] : Colors.grey
          ..style = PaintingStyle.fill);

    Path centerPath3 = Path()
      ..moveTo(9 * w, 9 * h)
      ..lineTo(6 * w, 9 * h)
      ..lineTo(7.5 * w, 7.5 * h)
      ..close();
    canvas.drawPath(
        centerPath3,
        Paint()
          ..color = activePlayers.contains(3) ? playerColors[3] : Colors.grey
          ..style = PaintingStyle.fill);

    Path centerPath4 = Path()
      ..moveTo(6 * w, 9 * h)
      ..lineTo(6 * w, 6 * h)
      ..lineTo(7.5 * w, 7.5 * h)
      ..close();
    canvas.drawPath(
        centerPath4,
        Paint()
          ..color = activePlayers.contains(0) ? playerColors[0] : Colors.grey
          ..style = PaintingStyle.fill);

    canvas.drawRect(Rect.fromLTWH(6 * w, 6 * h, 3 * w, 3 * h), strokePaint);
    canvas.drawLine(Offset(6 * w, 6 * h), Offset(9 * w, 9 * h), strokePaint);
    canvas.drawLine(Offset(9 * w, 6 * h), Offset(6 * w, 9 * h), strokePaint);
  }

  void _drawHomeBase(
      Canvas canvas, double x, double y, double w, double h, Color color) {
    Paint bgPaint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(x, y, 6 * w, 6 * h), bgPaint);

    Paint whiteBox = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(x + w, y + h, 4 * w, 4 * h), whiteBox);

    Paint spotPaint = Paint()..color = color;
    canvas.drawCircle(Offset(x + 2 * w, y + 2 * h), w / 2, spotPaint);
    canvas.drawCircle(Offset(x + 4 * w, y + 2 * h), w / 2, spotPaint);
    canvas.drawCircle(Offset(x + 2 * w, y + 4 * h), w / 2, spotPaint);
    canvas.drawCircle(Offset(x + 4 * w, y + 4 * h), w / 2, spotPaint);

    Paint borderPaint = Paint()
      ..color = Colors.black45
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(x, y, 6 * w, 6 * h), borderPaint);
  }

  void _drawStar(
      Canvas canvas, double cx, double cy, double radius, Color color) {
    int points = 5;
    double innerRadius = radius / 2;
    Path path = Path();
    double angle = -pi / 2;
    double step = pi / points;

    for (int i = 0; i < points * 2; i++) {
      double r = (i % 2 == 0) ? radius : innerRadius;
      double x = cx + cos(angle) * r;
      double y = cy + sin(angle) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      angle += step;
    }
    path.close();
    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
