export interface User {
  id: string;
  name: string;
  email: string;
  role: 'trainer' | 'member';
  profilePicture?: string;
}

export interface Workout {
  id: string;
  name: string;
  description: string;
  duration: number;
  caloriesBurn: number;
  difficulty: 'beginner' | 'intermediate' | 'advanced';
}

export interface MembershipPlan {
  id: string;
  name: string;
  duration: number;
  price: number;
  features: string[];
}

export interface Supplement {
  id: string;
  name: string;
  description: string;
  price: number;
  category: string;
  image: string;
  stock: number;
} 