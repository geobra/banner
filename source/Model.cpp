#include "Model.h"

#include <QSettings>

Model::Model(QObject *parent)
    : QAbstractListModel(parent)
{
    loadSettings();
}

int Model::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_entries.size();
}

QVariant Model::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_entries.size())
        return {};

    const Entry &entry = m_entries.at(index.row());
    switch (role) {
    case BannerTextRole:
        return entry.bannerText;
    case DurationTimeRole:
        return entry.durationTime;
    case IndexNrRole:
        return entry.indexNr;
    default:
        return {};
    }
}

bool Model::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_entries.size())
        return false;

    Entry &entry = m_entries[index.row()];
    switch (role) {
    case BannerTextRole:
        entry.bannerText = value.toString();
        break;
    case DurationTimeRole: {
        bool valid = false;
        const int duration = value.toInt(&valid);
        if (!valid || duration < 1 || duration > 100000)
            return false;
        entry.durationTime = duration;
        break;
    }
    case IndexNrRole: {
        const int effectIndex = value.toInt();
        if (effectIndex < 0 || effectIndex > 1)
            return false;
        entry.indexNr = effectIndex;
        break;
    }
    default:
        return false;
    }

    emit dataChanged(index, index, {role});
    saveSettings();
    return true;
}

QHash<int, QByteArray> Model::roleNames() const
{
    return {
        {BannerTextRole, "bannerText"},
        {DurationTimeRole, "durationTime"},
        {IndexNrRole, "indexNr"}
    };
}

QVariantMap Model::get(int row) const
{
    if (row < 0 || row >= m_entries.size())
        return {};

    const Entry &entry = m_entries.at(row);
    return {
        {QStringLiteral("bannerText"), entry.bannerText},
        {QStringLiteral("durationTime"), entry.durationTime},
        {QStringLiteral("indexNr"), entry.indexNr}
    };
}

void Model::append(const QVariantMap &entry)
{
    const int row = m_entries.size();
    beginInsertRows(QModelIndex(), row, row);
    m_entries.append({entry.value(QStringLiteral("bannerText"), QStringLiteral("message")).toString(),
                      entry.value(QStringLiteral("durationTime"), 1000).toInt(),
                      entry.value(QStringLiteral("indexNr"), 0).toInt()});
    endInsertRows();
    saveSettings();
}

void Model::remove(int row)
{
    if (row < 0 || row >= m_entries.size())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    m_entries.removeAt(row);
    endRemoveRows();
    saveSettings();
}

bool Model::setBannerText(int row, const QString &text)
{
    return setData(index(row), text, BannerTextRole);
}

bool Model::setDurationTime(int row, const QVariant &duration)
{
    return setData(index(row), duration, DurationTimeRole);
}

bool Model::setIndexNr(int row, int effectIndex)
{
    return setData(index(row), effectIndex, IndexNrRole);
}

void Model::loadSettings()
{
    QSettings settings;
    const int size = settings.beginReadArray(QStringLiteral("messages"));
    if (size == 0) {
        settings.endArray();
        m_entries = {
            {QStringLiteral(" LinuxOnMobile "), 1000, 0},
            {QStringLiteral("... with PostmarkteOS ..."), 2000, 1}
        };
        saveSettings();
        return;
    }

    m_entries.reserve(size);
    for (int row = 0; row < size; ++row) {
        settings.setArrayIndex(row);
        m_entries.append({settings.value(QStringLiteral("bannerText")).toString(),
                          settings.value(QStringLiteral("durationTime"), 1000).toInt(),
                          settings.value(QStringLiteral("indexNr"), 0).toInt()});
    }
    settings.endArray();
}

void Model::saveSettings() const
{
    QSettings settings;
    settings.beginWriteArray(QStringLiteral("messages"), m_entries.size());
    for (int row = 0; row < m_entries.size(); ++row) {
        settings.setArrayIndex(row);
        const Entry &entry = m_entries.at(row);
        settings.setValue(QStringLiteral("bannerText"), entry.bannerText);
        settings.setValue(QStringLiteral("durationTime"), entry.durationTime);
        settings.setValue(QStringLiteral("indexNr"), entry.indexNr);
    }
    settings.endArray();
    settings.sync();
}