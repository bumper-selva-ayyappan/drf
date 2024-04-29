from django.test import SimpleTestCase
from app import calc


class CalcTests(SimpleTestCase):

    def test_add_num(self):
        res = calc.add_num(5, 5)
        self.assertEqual(res, 10)

    def test_sub_num(self):
        res = calc.sub_num(6, 2)
        self.assertEqual(res, 4)
