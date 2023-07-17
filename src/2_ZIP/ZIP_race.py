##  Code with actual vs predicted and race as variable

import pandas as pd
import numpy as np
import statsmodels.api as sm
import matplotlib.pyplot as plt
from statsmodels.genmod import families
from patsy import dmatrices

# Load the data into a DataFrame
df = pd.read_csv('/Users/khushbooteotia/Documents/machineLearningTest/glucnormal_los.csv')
df.fillna(0, inplace=True)  # Account for NaNs in subset

df['diabetes_types'] = df['diabetes_types'].replace(0, 'none')
df['diabetes_types'] = df['diabetes_types'].replace(1.0, 'one')
df['diabetes_types'] = df['diabetes_types'].replace(2.0, 'two')
categorical_vars = ['diabetes_types']
dummy_vars1 = pd.get_dummies(df[categorical_vars])
df = pd.concat([df, dummy_vars1], axis=1)


categorical_vars = ['race']
dummy_vars = pd.get_dummies(df[categorical_vars])
race_df = pd.concat([df, dummy_vars], axis=1)

race_df.fillna(0, inplace=True)

split_index = int(len(race_df) * 0.7)  # 80% for training, 20% for testing

race_df_train = race_df[:split_index]
race_df_test = race_df[split_index:]
print('Training data set length=' + str(len(race_df_train)))
print('Testing data set length=' + str(len(race_df_test)))

expr = 'totalgluc_perLOS ~ age + sofa + charlson_comorbidity_index + hadInsulinDayOne + race + diabetes_types'
# add sex , add total insulin/LOS, 
y_train, X_train = dmatrices(expr, race_df_train, return_type='dataframe')
y_test, X_test = dmatrices(expr, race_df_test, return_type='dataframe')
zip_training_results = sm.ZeroInflatedPoisson(
endog=y_train, exog=X_train, exog_infl=X_train, inflation='logit'
).fit()

print(zip_training_results.summary())

# Extract coefficient names and values
coef_names = zip_training_results.params.index
coef_values = zip_training_results.params.values

# Calculate exponentiated coefficients
coef_exp = np.exp(coef_values)
print(coef_exp)

zip_predictions = zip_training_results.predict(X_test, exog_infl=X_test)
predicted_counts = np.round(zip_predictions)
actual_counts = y_test['totalgluc_perLOS']
print('ZIP RMSE=' + str(np.sqrt(np.sum(np.power(np.subtract(predicted_counts, actual_counts), 2)))))

# Normalization
#scaler = MinMaxScaler(feature_range=(0, 1))
#actual_counts_normalized = scaler.fit_transform(np.array(actual_counts).reshape(-1, 1))
#predicted_counts_normalized = scaler.transform(np.array(predicted_counts).reshape(-1, 1))

fig = plt.figure()
fig.suptitle('Predicted versus actual counts using the ZIP model')
plt.scatter(actual_counts, predicted_counts)
plt.xlabel('Actual Counts')
plt.ylabel('Predicted Counts')
plt.ylim(0,100)
plt.xlim(0,100)
plt.show()
