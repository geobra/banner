#ifndef MODEL_H
#define MODEL_H

#include <QAbstractListModel>
#include <QVariantMap>

class Model : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        BannerTextRole = Qt::UserRole + 1,
        DurationTimeRole,
        IndexNrRole
    };
    Q_ENUM(Roles)

    explicit Model(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE QVariantMap get(int row) const;
    Q_INVOKABLE void append(const QVariantMap &entry);
    Q_INVOKABLE void remove(int row);
    Q_INVOKABLE bool moveRow(int from, int to);
    Q_INVOKABLE bool setBannerText(int row, const QString &text);
    Q_INVOKABLE bool setDurationTime(int row, const QVariant &duration);
    Q_INVOKABLE bool setIndexNr(int row, int index);

private:
    struct Entry {
        QString bannerText;
        int durationTime;
        int indexNr;
    };

    void loadSettings();
    void saveSettings() const;

    QList<Entry> m_entries;
};

#endif // MODEL_H