export interface Product {
  availableToStores: string[];
  categoryId: string;
  cost: number; // capital cost for stats only
  docId: string;
  imageUrl: string;
  modifierGroupIds: string[];
  name: string;
  order: number; // order in the product
  price: number; // price of the product
}
