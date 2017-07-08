import pandas as pd
import numpy as np
import sklearn
args = pd.read_csv('args.csv')
test_args = pd.read_csv('args_test.csv')
args2 = pd.get_dummies(data=args,columns=['floor_group','max_floor_group','material','room_group','kitch_group','state','product_type'],dummy_na=True)
from sklearn.tree import DecisionTreeClassifier
Y=args2['price_doc']
del args2['price_doc']

test_args2 = pd.get_dummies(data=test_args,columns=['floor_group','max_floor_group','material','room_group','kitch_group','state','product_type'],dummy_na=True)
ids=test_args2['id']
del test_args2['id']

from sklearn.ensemble import GradientBoostingRegressor
gb=GradientBoostingRegressor().fit(args2,Y)
result = gb.predict(test_args2)
d=pd.DataFrame({'id':test_args['id'],'price_doc':result})
d.set_index('id', inplace=True)
d.to_csv('Gradient-result.csv')
d.shape

