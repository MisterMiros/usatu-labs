#!/usr/bin/python3
import sys
from PyQt5 import QtCore, QtGui, QtWidgets

from process import *
from fifs import fifs_processes_gen
from rr import rr_processes_gen
from sjf import sjf_processes_gen
from gui import Ui_MainWindow
from itertools import zip_longest

MainWindow = None
ui = None
procs = None

def init_ui():
    global MainWindow
    global ui
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    connect_signals(ui)
    MainWindow.show()
    sys.exit(app.exec_())

def connect_signals(ui):
    ui.openFile.clicked.connect(open_file)
    ui.applyAlgorithms.clicked.connect(apply_algorithms)

def open_file():
    fname = QtWidgets.QFileDialog.getOpenFileName(MainWindow, 'Открыть файл')[0]
    file = open(fname, "r")
    global procs
    with file:
        procs_temp = [[int(n) for n in l.split(" ")] for l in file]
        procs = [Process(i, p[0], p[1], p[2]) for i, p in enumerate(procs_temp)]
    fill_procs_table(procs, ui.processesTable)

def fill_procs_table(procs, table):
    table.setRowCount(0)
    for i, p in enumerate(procs):
        table.insertRow(i)
        table.setItem(i, 0, QtWidgets.QTableWidgetItem(str(p.name)))
        table.setItem(i, 1, QtWidgets.QTableWidgetItem(str(p.start)))
        table.setItem(i, 2, QtWidgets.QTableWidgetItem(str(p.duration)))
        table.setItem(i, 3, QtWidgets.QTableWidgetItem(str(p.kind)))
    table.resizeColumnsToContents()

def apply_algorithms():
    procs_1 = [p.copy() for p in procs]
    procs_2 = [p.copy() for p in procs]
    procs_3 = [p.copy() for p in procs]
    fifs_result = [p for p in fifs_processes_gen(procs_1)]
    step = ui.rrStep.value()
    rr_result = [p for p in rr_processes_gen(procs_2, step)]
    sjf_result = [p for p in sjf_processes_gen(procs_3)]
    result = zip_longest(fifs_result, rr_result, sjf_result)
    fill_results_table(result, ui.resultsTable)
    lst = ui.resultsTable.rowCount()
    ui.resultsTable.insertRow(lst)
    ui.resultsTable.setItem(lst, 0, QtWidgets.QTableWidgetItem("Среднее время работы: "))
    ui.resultsTable.setItem(lst, 1, QtWidgets.QTableWidgetItem(str(average_time(procs, fifs_result))))
    ui.resultsTable.setItem(lst, 2, QtWidgets.QTableWidgetItem(str(average_time(procs, rr_result))))
    ui.resultsTable.setItem(lst, 3, QtWidgets.QTableWidgetItem(str(average_time(procs, sjf_result))))
    ui.resultsTable.resizeColumnsToContents()

def fill_results_table(result, table):
    table.setRowCount(0)
    for i, r in enumerate(result):
        table.insertRow(i)
        table.setItem(i, 0, QtWidgets.QTableWidgetItem(str(i)))
        table.setItem(i, 1, QtWidgets.QTableWidgetItem(str(r[0])))
        table.setItem(i, 2, QtWidgets.QTableWidgetItem(str(r[1])))
        table.setItem(i, 3, QtWidgets.QTableWidgetItem(str(r[2])))

def average_time(procs, times):
    summa = 0
    for p in procs:
        start = p.start
        finish = last_index(p, times) + 1
        summa += finish - start
    return summa / len(procs)

def last_index(it, lst):
    return len(lst) - 1 - lst[::-1].index(it)

init_ui()


