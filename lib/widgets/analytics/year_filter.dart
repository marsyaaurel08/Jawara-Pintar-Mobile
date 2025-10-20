import 'package:flutter/material.dart';

/// Year filter dengan dropdown untuk memilih tahun
class YearFilter extends StatefulWidget {
  final int selectedYear;
  final Function(int) onYearChanged;
  final List<int>? availableYears;

  const YearFilter({
    super.key,
    required this.selectedYear,
    required this.onYearChanged,
    this.availableYears,
  });

  @override
  State<YearFilter> createState() => _YearFilterState();
}

class _YearFilterState extends State<YearFilter> {
  bool _isExpanded = false;
  late int _currentRangeStart;

  @override
  void initState() {
    super.initState();
    // Start range based on current selected year
    _currentRangeStart = ((widget.selectedYear - 1) ~/ 10) * 10 + 1;
  }

  void _showYearPicker() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _previousDecade() {
    setState(() {
      _currentRangeStart -= 10;
    });
  }

  void _nextDecade() {
    setState(() {
      _currentRangeStart += 10;
    });
  }

  void _selectYear(int year) {
    widget.onYearChanged(year);
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Year selector button
          InkWell(
            onTap: _showYearPicker,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.selectedYear.toString(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),

          // Year grid picker (seperti gambar)
          if (_isExpanded) ...[
            Divider(height: 1, color: Colors.grey.shade200),
            Container(
              width: 280,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Navigation header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_double_arrow_left),
                        onPressed: _previousDecade,
                        iconSize: 18,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Text(
                        '$_currentRangeStart – ${_currentRangeStart + 9}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.keyboard_double_arrow_right),
                        onPressed: _nextDecade,
                        iconSize: 18,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Year grid (3 kolom x 4 baris = 12 tahun, tapi 10 yang aktif)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.8,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final year = _currentRangeStart + index;
                      final isSelected = year == widget.selectedYear;

                      return InkWell(
                        onTap: () => _selectYear(year),
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            year.toString(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
