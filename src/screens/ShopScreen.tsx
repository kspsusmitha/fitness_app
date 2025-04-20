import React from 'react';
import { View, Text, StyleSheet, FlatList, Image, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Supplement } from '../types';

const sampleSupplements: Supplement[] = [
  {
    id: '1',
    name: 'Whey Protein',
    description: 'High-quality protein powder for muscle recovery',
    price: 49.99,
    category: 'Protein',
    image: 'https://example.com/whey.jpg',
    stock: 50,
  },
  {
    id: '2',
    name: 'BCAA Complex',
    description: 'Branch Chain Amino Acids for muscle preservation',
    price: 29.99,
    category: 'Amino Acids',
    image: 'https://example.com/bcaa.jpg',
    stock: 30,
  },
];

const ShopScreen = () => {
  const renderSupplementCard = ({ item }: { item: Supplement }) => (
    <TouchableOpacity style={styles.card}>
      <View style={styles.imageContainer}>
        <Image
          source={{ uri: item.image }}
          style={styles.image}
          defaultSource={require('../assets/placeholder.png')}
        />
      </View>
      <View style={styles.cardContent}>
        <Text style={styles.name}>{item.name}</Text>
        <Text style={styles.category}>{item.category}</Text>
        <Text style={styles.description} numberOfLines={2}>
          {item.description}
        </Text>
        <View style={styles.footer}>
          <Text style={styles.price}>${item.price}</Text>
          <TouchableOpacity style={styles.addButton}>
            <Text style={styles.addButtonText}>Add to Cart</Text>
          </TouchableOpacity>
        </View>
      </View>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Supplements Shop</Text>
      </View>
      <FlatList
        data={sampleSupplements}
        renderItem={renderSupplementCard}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.list}
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  header: {
    padding: 20,
    backgroundColor: '#fff',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  list: {
    padding: 16,
  },
  card: {
    backgroundColor: '#fff',
    borderRadius: 10,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
    elevation: 5,
  },
  imageContainer: {
    height: 200,
    borderTopLeftRadius: 10,
    borderTopRightRadius: 10,
    overflow: 'hidden',
  },
  image: {
    width: '100%',
    height: '100%',
    resizeMode: 'cover',
  },
  cardContent: {
    padding: 16,
  },
  name: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  category: {
    fontSize: 14,
    color: '#666',
    marginBottom: 8,
  },
  description: {
    fontSize: 14,
    color: '#444',
    marginBottom: 12,
  },
  footer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  price: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#2196F3',
  },
  addButton: {
    backgroundColor: '#2196F3',
    padding: 8,
    borderRadius: 5,
  },
  addButtonText: {
    color: '#fff',
    fontWeight: 'bold',
  },
});

export default ShopScreen; 