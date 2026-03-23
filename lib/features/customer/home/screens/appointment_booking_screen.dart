import 'package:flutter/material.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({
    super.key,
    required this.title,
    required this.location,
  });

  final String title;
  final String location;

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  static const _bg = Color(0xFFEEF3F7);
  static const _dark = Color(0xFF1E2D3C);
  static const _orange = Color(0xFFE67E22);

  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime.now();

  final List<String> _timeOptions = const [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ];

  String _startTime = '10:00';
  String _endTime = '14:00';

  @override
  Widget build(BuildContext context) {
    final monthLabel = _formatMonthYear(_focusedMonth);
    final dateLabel = _formatLongDate(_selectedDate);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(22),
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Prise de rendez - vous',
                    style: TextStyle(
                      color: _dark,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 44, height: 44),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AgencyCard(title: widget.title, location: widget.location),
                    const SizedBox(height: 18),
                    const Text(
                      'Choisir une date',
                      style: TextStyle(
                        color: _orange,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: _openDateSelector,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 18,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  monthLabel,
                                  style: const TextStyle(
                                    color: _dark,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                _MonthArrow(
                                  icon: Icons.chevron_left_rounded,
                                  onTap: _prevMonth,
                                ),
                                const SizedBox(width: 6),
                                _MonthArrow(
                                  icon: Icons.chevron_right_rounded,
                                  onTap: _nextMonth,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _CalendarMonthView(
                              month: _focusedMonth,
                              selectedDate: _selectedDate,
                              onSelect: (d) =>
                                  setState(() => _selectedDate = d),
                              compact: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Choisir une heure',
                      style: TextStyle(
                        color: _orange,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _TimeDropdown(
                            value: _startTime,
                            items: _timeOptions,
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() => _startTime = v);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'à',
                          style: TextStyle(
                            color: _dark,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _TimeDropdown(
                            value: _endTime,
                            items: _timeOptions,
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() => _endTime = v);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _dark,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 20,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded,
                        color: _orange, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        dateLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(width: 1, height: 18, color: Colors.white24),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time_rounded,
                        color: _orange, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '${_startTime.replaceAll(':', '.')}-${_endTime.replaceAll(':', '.')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _orange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    onPressed: _confirm,
                    child: const Text(
                      'Prendre un rendez - vous',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _prevMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  Future<void> _openDateSelector() async {
    final initialMonth = _focusedMonth;
    final initialSelected = _selectedDate;

    DateTime sheetMonth = initialMonth;
    DateTime sheetSelected = initialSelected;

    final result = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _DateSelectorSheet(
          initialMonth: sheetMonth,
          initialSelected: sheetSelected,
          onMonthChanged: (m) => sheetMonth = m,
          onSelectedChanged: (d) => sheetSelected = d,
        );
      },
    );

    if (result == null) return;

    setState(() {
      _selectedDate = result;
      _focusedMonth = DateTime(result.year, result.month);
    });
  }

  Future<void> _confirm() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _ConfirmationSheet(
          onBackHome: () {
            Navigator.of(ctx).pop();
            Navigator.of(context).popUntil((r) => r.isFirst);
          },
        );
      },
    );
  }

  static String _formatMonthYear(DateTime date) {
    const months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  static String _formatLongDate(DateTime date) {
    const months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _AgencyCard extends StatelessWidget {
  const _AgencyCard({required this.title, required this.location});

  final String title;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3F7),
              borderRadius: BorderRadius.circular(22),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.home_rounded, color: Color(0xFF1E2D3C)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1E2D3C),
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: const TextStyle(
                    color: Color(0xFF8A97A6),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthArrow extends StatelessWidget {
  const _MonthArrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: const Color(0xFF1E2D3C)),
      ),
    );
  }
}

class _TimeDropdown extends StatelessWidget {
  const _TimeDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items
              .map(
                (t) => DropdownMenuItem(
                  value: t,
                  child: Text(
                    t,
                    style: const TextStyle(
                      color: Color(0xFF1E2D3C),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _DateSelectorSheet extends StatefulWidget {
  const _DateSelectorSheet({
    required this.initialMonth,
    required this.initialSelected,
    required this.onMonthChanged,
    required this.onSelectedChanged,
  });

  final DateTime initialMonth;
  final DateTime initialSelected;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onSelectedChanged;

  @override
  State<_DateSelectorSheet> createState() => _DateSelectorSheetState();
}

class _DateSelectorSheetState extends State<_DateSelectorSheet> {
  static const _dark = Color(0xFF1E2D3C);

  late DateTime _month;
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _month = widget.initialMonth;
    _selected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Selectionner Date',
              style: TextStyle(
                color: _dark,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                InkWell(
                  onTap: _prev,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.chevron_left_rounded),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatMonthYear(_month),
                  style: const TextStyle(
                    color: _dark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: _next,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.chevron_right_rounded),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _CalendarMonthView(
              month: _month,
              selectedDate: _selected,
              onSelect: (d) {
                setState(() => _selected = d);
                widget.onSelectedChanged(d);
              },
              compact: false,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(
                        color: Color(0xFFFF2D55),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _dark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(_selected),
                      child: const Text(
                        'Appliquer',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _prev() {
    setState(() {
      _month = DateTime(_month.year, _month.month - 1);
      widget.onMonthChanged(_month);
    });
  }

  void _next() {
    setState(() {
      _month = DateTime(_month.year, _month.month + 1);
      widget.onMonthChanged(_month);
    });
  }

  static String _formatMonthYear(DateTime date) {
    const months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _CalendarMonthView extends StatelessWidget {
  const _CalendarMonthView({
    required this.month,
    required this.selectedDate,
    required this.onSelect,
    required this.compact,
  });

  final DateTime month;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelect;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    final startWeekday = (firstDay.weekday + 6) % 7; // Mon=0..Sun=6
    final totalCells = ((startWeekday + daysInMonth) / 7).ceil() * 7;

    const weekDays = ['Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa', 'Di'];

    final cellSize = compact ? 38.0 : 44.0;

    return Column(
      children: [
        Row(
          children: weekDays
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: const TextStyle(
                        color: Color(0xFF1E2D3C),
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalCells,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final dayNumber = index - startWeekday + 1;
            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return const SizedBox.shrink();
            }

            final date = DateTime(month.year, month.month, dayNumber);
            final selected = date.year == selectedDate.year &&
                date.month == selectedDate.month &&
                date.day == selectedDate.day;

            return InkWell(
              onTap: () => onSelect(date),
              borderRadius: BorderRadius.circular(cellSize / 2),
              child: Container(
                width: cellSize,
                height: cellSize,
                decoration: BoxDecoration(
                  color:
                      selected ? const Color(0xFFE67E22) : Colors.transparent,
                  borderRadius: BorderRadius.circular(cellSize / 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$dayNumber',
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF1E2D3C),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ConfirmationSheet extends StatelessWidget {
  const _ConfirmationSheet({required this.onBackHome});

  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 22),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(60),
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/images/confirmRDV.png',
                  width: 90, height: 90),
            ),
            const SizedBox(height: 20),
            const Text(
              'Votre rendez-vous a été confirmé avec succès',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1E2D3C),
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE67E22),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: onBackHome,
                child: const Text(
                  'Retour à l’accueil',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
