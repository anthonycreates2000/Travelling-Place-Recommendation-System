import os
import tensorflow as tf

class ModelLoader():
    def load_collaborative_filtering_model(self):
        model_path = os.path.join(os.path.dirname(__file__), "../ml_models/best_model_efficient_deep_learning_2")
        loaded_model = tf.keras.saving.load_model(model_path)
        return loaded_model
