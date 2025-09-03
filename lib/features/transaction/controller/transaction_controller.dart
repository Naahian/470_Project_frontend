import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_app/features/transaction/model/transaction_model.dart';
import 'package:inventory_management_app/features/transaction/model/transaction_service.dart';
import 'package:inventory_management_app/features/transaction/model/transactiondetail_model.dart';

enum TransactionFilter { ALL, SELL, ORDER }

class TransactionState {
  final List<TransactionModel> transactions;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final TransactionFilter currentFilter;
  final dynamic selectedTransaction;
  final String? selectedType;
  final bool loadingSelected;

  const TransactionState({
    this.transactions = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedTransaction,
    this.currentFilter = TransactionFilter.ALL,
    this.selectedType,
    this.loadingSelected = false,
  });

  TransactionState copyWith({
    List<TransactionModel>? transactions,
    List<TransactionModel>? filteredTransactions,
    bool? isLoading,
    String? error,
    String? searchQuery,
    TransactionFilter? currentFilter,
    dynamic selectedTransaction,
    String? selectedType,
    bool? loadingSelected,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      currentFilter: currentFilter ?? this.currentFilter,
      selectedTransaction: selectedTransaction ?? this.selectedTransaction,
      selectedType: selectedType ?? this.selectedType,
      loadingSelected: loadingSelected ?? this.loadingSelected,
    );
  }

  List<TransactionModel> get filteredTransactions {
    return transactions.where((transaction) {
      final matchesSearch =
          searchQuery.isEmpty ||
          transaction.id.toString().contains(searchQuery);
      final matchesFilter =
          currentFilter == TransactionFilter.ALL ||
          transaction.type == currentFilter.name;
      return matchesSearch && matchesFilter;
    }).toList();
  }
}

class TransactionController extends StateNotifier<TransactionState> {
  TransactionController() : super(const TransactionState()) {
    loadInitials();
  }

  void loadInitials() async {
    // admin ? _getAllTransactions() : _getSells();
    _getAllTransactions();
  }

  void _getAllTransactions() async {
    //admin user
    final response = await TransactionService().getAllTransactions();
    final List<TransactionModel> transactions = response
        .map<TransactionModel>((item) => TransactionModel.fromJson(item))
        .toList();

    state = state.copyWith(
      transactions: transactions,
      filteredTransactions: transactions,
    );
  }

  void _getSells() async {
    final response = await TransactionService().getAllSells();
    final List<TransactionModel> transactions = response
        .map<TransactionModel>((item) => TransactionModel.fromJson(item))
        .toList();

    state = state.copyWith(
      transactions: transactions,
      filteredTransactions: transactions,
    );
  }

  void getSingleTransaction(int id) async {
    state = state.copyWith(loadingSelected: true);
    final result = await TransactionService().getSingleTransaction('$id');
    if (result['type'] == 'SELL') {
      state = state.copyWith(
        selectedTransaction: SellModel.fromJson(result),
        selectedType: 'SELL',
        loadingSelected: false,
      );
    } else {
      state = state.copyWith(
        selectedTransaction: OrderModel.fromJson(result),
        selectedType: 'ORDER',
        loadingSelected: false,
      );
    }
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    print(state.currentFilter);
  }

  void updateFilter(int index) {
    TransactionFilter filter;

    switch (index) {
      case 1:
        filter = TransactionFilter.SELL;
        break;
      case 2:
        filter = TransactionFilter.ORDER;
        break;
      default:
        filter = TransactionFilter.ALL;
        break;
    }
    state = state.copyWith(currentFilter: filter);
  }
}

final transactionControllerProvider =
    StateNotifierProvider<TransactionController, TransactionState>(
      (ref) => TransactionController(),
    );
