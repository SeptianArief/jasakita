import 'package:equatable/equatable.dart';
import 'package:qixer/app/home/models/categories_model.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesFailed extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Categories> data;

  const CategoriesLoaded(this.data);

  @override
  List<Object> get props => [data];
}
