import numpy as np
import pandas as pd

class ColabBasedFiltering():
    def make_recommendations(self, tourism_test_df, original_tourism_df, model):
        # Creating dataset for making recommendations for the first user
        tourism_test_data = np.array(list(tourism_test_df.Place_Id))
        user_test_data = tourism_test_df.User_Id.iloc[0]

        tourism_not_visited_data = original_tourism_df[~original_tourism_df['Place_Id'].isin(tourism_test_data)]['Place_Id']
        tourism_not_visited_data = list(tourism_not_visited_data)
        user_test_data = [user_test_data] * len(tourism_not_visited_data)

        new_user_tourism_data_df = pd.DataFrame(
            {
                "Place_Id": tourism_not_visited_data,
                "User_Id": user_test_data,
            },
        )

        predictions = model.predict([
            new_user_tourism_data_df.User_Id, new_user_tourism_data_df.Place_Id]
        )

        predictions = np.array([a[0] for a in predictions])
        recommended_tourism_ids = (-predictions).argsort()[:10]

        recommended_tourism_df = original_tourism_df[original_tourism_df["Place_Id"].isin(recommended_tourism_ids)]
        recommended_tourism_df["Lat"] = recommended_tourism_df["Lat"].astype(float)
        recommended_tourism_df["Long"] = recommended_tourism_df["Long"].astype(float)

        return recommended_tourism_df