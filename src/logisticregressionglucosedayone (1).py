# -*- coding: utf-8 -*-
"""logisticRegressionGlucoseDayOne.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1EUS2ZGjZhcaMSRuR1YJeDUVpe8zKvMSH
"""

from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.metrics import classification_report
from sklearn.utils import resample
from imblearn.over_sampling import SMOTE
import numpy as np

from sklearn.preprocessing import LabelEncoder
import pandas as pd
import os
current_path = os.path.abspath('.')
label_encoder = LabelEncoder()
fi=os.path.abspath('../../data/cohortedData.csv')
print(fi)
data = pd.read_csv(fi)

data['race'].unique()

data.info()

data.fillna(0, inplace=True)
data['diabetes_types'] = data['diabetes_types'].replace(0, 'none')
data['diabetes_types'] = data['diabetes_types'].replace(1.0, 'one')
data['diabetes_types'] = data['diabetes_types'].replace(2.0, 'two')
data['race'] = data['race'].replace('OTHER', 'Other')

data['admElective'] = label_encoder.fit_transform(data['admElective'])
data['hadInsulinDayOne'] = label_encoder.fit_transform(data['hadInsulinDayOne'])
data['hadMeasurmentDayOne'] = label_encoder.fit_transform(data['hadMeasurmentDayOne'])
niceColumns=["uti", "biliary", "skin",'sofa', 'hypertension_present','heart_failure_present','copd_present','cad_present']

categorical_vars = ['anchor_year_group', 'race','diabetes_types']
dummy_vars = pd.get_dummies(data[categorical_vars])
dummy_vars = dummy_vars.drop(columns=['race_Other'])
dummy_vars = dummy_vars.drop(columns=['race_White'])
dummy_vars = dummy_vars.drop(columns=['anchor_year_group_2008 - 2010'])
dummy_vars = dummy_vars.drop(columns=['diabetes_types_none'])

data = pd.concat([data, dummy_vars], axis=1)



continuous_vars = ['ckd_stages','age','charlson_comorbidity_index','diabetes_with_cc','diabetes_without_cc']
#,'sofa','cardiovascular','cns','coagulation','liver','renal','respiration'
independent = data[continuous_vars + list(dummy_vars.columns)+niceColumns]
dependent = data['hadMeasurmentDayOne']



from sklearn.metrics import roc_curve
import matplotlib.pyplot as plt
def test_model(X_test, y_test, model):

    y_pred = model.predict(X_test)
    print(classification_report(y_true=y_test, y_pred=y_pred))
    fpr, tpr, _ = roc_curve(y_test,  y_pred)

    #create ROC curve
    plt.plot(fpr,tpr)
    plt.title('ROC Curve')
    plt.ylabel('True Positive Rate')
    plt.xlabel('False Positive Rate')
    plt.show()

#all patients
import statsmodels.api as sm



X_train, X_test, y_train, y_test = train_test_split(independent, dependent, test_size=0.25, random_state=16)



minority_x = X_train[y_train==0]
minority_y = y_train[y_train==0]
majority_x = X_train[y_train==1]
majority_y = y_train[y_train==1]

# Perform oversampling on the minority class
minority_size = len(minority_x)
majority_size = len(majority_x)

oversampled_minority_x, oversampled_minority_y = resample(
minority_x, minority_y, replace=True, n_samples=len(majority_x)
)


# Combine oversampled minority and majority
x_train_final = pd.concat([oversampled_minority_x, majority_x])
y_train_final = pd.concat([oversampled_minority_y, majority_y])

logit_model = sm.Logit(y_train_final, x_train_final)
logit_model.fit_regularized(start_params=None,method = 'l1',alpha = 0)
result = logit_model.fit()
odds_ratio = np.exp(result.params)
ci = np.exp(result.conf_int())

# Create a DataFrame to display the results
results_df = pd.DataFrame({'Odds Ratio': odds_ratio, 'Lower CI': ci[0], 'Upper CI': ci[1]})
print(results_df)
# Find the odds ratio and its confidence interval

y_test

predicted_probs = result.predict(X_test)

# Convert predicted probabilities to binary predictions (0 or 1)
predicted_values = (predicted_probs >= 0.5).astype(int)

# Compare predicted values with actual values and calculate accuracy
accuracy = (predicted_values == y_test).mean()

accuracy

result.summary()

